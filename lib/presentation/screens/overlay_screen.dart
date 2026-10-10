import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../../domain/models/translation_models.dart';
import '../theme/app_colors.dart';

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({Key? key}) : super(key: key);

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  List<ExtractedTextNode> _nodes = [];

  @override
  void initState() {
    super.initState();
    // Listen to data coming from the main app isolate via FlutterOverlayWindow.shareData
    FlutterOverlayWindow.overlayListener.listen((event) {
      if (event is List) {
        setState(() {
          _nodes = event.map((e) => ExtractedTextNode.fromMap(Map<String, dynamic>.from(e))).toList();
        });
      }
    });
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
