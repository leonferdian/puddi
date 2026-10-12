import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_accessibility_service/accessibility_event.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import '../models/translation_models.dart';

abstract class AccessibilityService {
  Future<bool> requestAccessibilityPermission();
  Future<bool> isAccessibilityGranted();
  Stream<List<ExtractedTextNode>> get textNodesStream;
  Future<void> startService();
  Future<void> stopService();
}

class AndroidAccessibilityService implements AccessibilityService {
  StreamSubscription<AccessibilityEvent>? _subscription;
  final StreamController<List<ExtractedTextNode>> _nodesController =
      StreamController<List<ExtractedTextNode>>.broadcast();

  @override
  Future<bool> requestAccessibilityPermission() async {
    try {
      final bool status = await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
      if (!status) {
        return await FlutterAccessibilityService.requestAccessibilityPermission();
      }
      return true;
    } catch (e) {
      debugPrint("[AccessibilityService] Error requesting permission: $e");
      return false;
    }
  }

  @override
  Future<bool> isAccessibilityGranted() async {
    try {
      return await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
    } catch (e) {
      debugPrint("[AccessibilityService] Error checking permission: $e");
      return false;
    }
  }

  @override
  Stream<List<ExtractedTextNode>> get textNodesStream => _nodesController.stream;

  @override
  Future<void> startService() async {
    await _subscription?.cancel();
    _subscription = FlutterAccessibilityService.accessStream.listen(
      (AccessibilityEvent event) {
        final List<ExtractedTextNode> extracted = [];

        void processNode(AccessibilityEvent node) {
          final text = node.text?.trim() ?? '';
          final bounds = node.screenBounds;

          // Diagnostic logging to isolate failure in text extraction vs UI rendering
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
            processNode(child);
          }
        } else {
          processNode(event);
        }

        if (extracted.isNotEmpty) {
          _nodesController.add(extracted);
        }
      },
      onError: (error) {
        debugPrint("[AccessibilityService] Stream error: $error");
      },
    );
  }

  @override
  Future<void> stopService() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}

