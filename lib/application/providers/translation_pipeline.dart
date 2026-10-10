import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state_providers.dart';
import '../../domain/models/translation_models.dart';

class TranslationPipeline {
  final Ref ref;
  StreamSubscription<List<ExtractedTextNode>>? _ocrSubscription;
  bool _isProcessing = false;

  TranslationPipeline(this.ref) {
    _initPipeline();
  }

  void _initPipeline() {
    final screenCaptureService = ref.read(screenCaptureServiceProvider);
    
    // Listen to the OCR stream coming from Kotlin MethodChannel
    _ocrSubscription = screenCaptureService.ocrTextNodesStream.listen((nodes) {
      _processNodes(nodes);
    });
  }

  Future<void> _processNodes(List<ExtractedTextNode> nodes) async {
    final state = ref.read(serviceStateProvider);
    
    // Only process if the daemon is active and we're not currently processing a batch
    if (!state.isDaemonRunning || _isProcessing || nodes.isEmpty) return;

    _isProcessing = true;
    try {
      final translationService = ref.read(translationServiceProvider);
      final overlayService = ref.read(overlayServiceProvider);

      // Translate each node. (In production, you'd batch these into one API call to save latency)
      final List<ExtractedTextNode> translatedNodes = [];
      
      for (var node in nodes) {
        // Skip empty strings
        if (node.text.trim().isEmpty) continue;
        
        final translatedText = await translationService.translateText(
          text: node.text,
          sourceLanguage: state.sourceLanguage,
          targetLanguage: state.targetLanguage,
          apiKey: state.apiKey,
        );

        translatedNodes.add(node.copyWith(translatedText: translatedText));
      }

      // Send the translated text and bounds to the overlay service
      await overlayService.updateOverlayNodes(translatedNodes);
      
    } catch (e) {
      debugPrint("Pipeline Error: $e");
    } finally {
      _isProcessing = false;
    }
  }

  void dispose() {
    _ocrSubscription?.cancel();
  }
}

// Global provider for the pipeline
final translationPipelineProvider = Provider<TranslationPipeline>((ref) {
  final pipeline = TranslationPipeline(ref);

  // Listen to state changes to automatically start/stop native captures
  ref.listen(serviceStateProvider, (previous, next) async {
    final wasRunning = previous?.isDaemonRunning ?? false;
    
    if (!wasRunning && next.isDaemonRunning) {
      // 1. Ensure overlay is granted
      await ref.read(overlayServiceProvider).requestOverlayPermission();
      
      // 2. Request screen capture. 
      // Our Kotlin code is written such that accepting this prompt automatically starts the background foreground service!
      await ref.read(screenCaptureServiceProvider).requestScreenCapturePermission();
    } else if (wasRunning && !next.isDaemonRunning) {
      // Pause service
      await ref.read(screenCaptureServiceProvider).stopCapture();
      await ref.read(overlayServiceProvider).closeOverlay();
    }
  });

  ref.onDispose(() => pipeline.dispose());
  return pipeline;
});
