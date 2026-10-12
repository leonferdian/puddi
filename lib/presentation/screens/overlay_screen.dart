import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_accessibility_service/accessibility_event.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../../domain/models/translation_models.dart';
import '../theme/app_colors.dart';

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  List<ExtractedTextNode> _nodes = [];
  StreamSubscription<AccessibilityEvent>? _accessibilitySubscription;
  StreamSubscription<dynamic>? _overlayListenerSubscription;

  @override
  void initState() {
    super.initState();
    _initBackgroundAccessibilityListener();
    _initOverlayChannelListener();
  }

  void _initBackgroundAccessibilityListener() {
    // Phase 1: EventChannel listening to the AccessibilityService running inside this background isolate
    _accessibilitySubscription = FlutterAccessibilityService.accessStream.listen(
      (AccessibilityEvent event) {
        _handleAccessibilityEvent(event);
      },
      onError: (error) {
        debugPrint("[BackgroundIsolate] Accessibility stream error: $error");
      },
    );
  }

  void _initOverlayChannelListener() {
    // Listen to data from the main app isolate via FlutterOverlayWindow.shareData
    _overlayListenerSubscription = FlutterOverlayWindow.overlayListener.listen((event) {
      if (event is List) {
        setState(() {
          _nodes = event.map((e) => ExtractedTextNode.fromMap(Map<String, dynamic>.from(e))).toList();
        });
      }
    });
  }

  void _handleAccessibilityEvent(AccessibilityEvent event) {
    final List<ExtractedTextNode> extracted = [];

    void inspectNode(AccessibilityEvent node) {
      final text = node.text?.trim() ?? '';
      final bounds = node.screenBounds;

      // Phase 2: Diagnostic logging inside the Flutter accessibility stream listener
      debugPrint(
        "[AccessibilityDiagnostic] node.text: '$text', node.boundsInScreen: "
        "[L:${bounds?.left}, T:${bounds?.top}, R:${bounds?.right}, B:${bounds?.bottom}]",
      );

      if (text.isNotEmpty &&
          bounds != null &&
          bounds.left != null &&
          bounds.top != null &&
          bounds.right != null &&
          bounds.bottom != null) {
        extracted.add(
          ExtractedTextNode(
            text: text,
            boundingBox: Rect.fromLTRB(
              bounds.left!.toDouble(),
              bounds.top!.toDouble(),
              bounds.right!.toDouble(),
              bounds.bottom!.toDouble(),
            ),
          ),
        );
      }
    }

    if (event.subNodes != null && event.subNodes!.isNotEmpty) {
      for (final child in event.subNodes!) {
        inspectNode(child);
      }
    } else {
      inspectNode(event);
    }

    if (extracted.isNotEmpty) {
      setState(() {
        _nodes = extracted;
      });
    }
  }

  @override
  void dispose() {
    _accessibilitySubscription?.cancel();
    _overlayListenerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold must be completely transparent to let the game/app show underneath
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: _nodes.map((node) => _buildTranslationBubble(node)).toList(),
      ),
    );
  }

  Widget _buildTranslationBubble(ExtractedTextNode node) {
    if (node.translatedText == null || node.translatedText!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Draw the translation bubble directly over the extracted text bounding box
    return Positioned(
      left: node.boundingBox.left,
      top: node.boundingBox.top,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - node.boundingBox.left - 16,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest.withOpacity(0.95),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryContainer.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Text(
          node.translatedText!,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
