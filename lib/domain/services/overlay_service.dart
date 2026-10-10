import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../models/translation_models.dart';

abstract class OverlayService {
  Future<bool> requestOverlayPermission();
  Future<void> showOverlay();
  Future<void> closeOverlay();
  Future<void> updateOverlayNodes(List<ExtractedTextNode> nodes);
}

class FlutterOverlayService implements OverlayService {
  @override
  Future<bool> requestOverlayPermission() async {
    final bool? status = await FlutterOverlayWindow.isPermissionGranted();
    if (status != true) {
      final bool? granted = await FlutterOverlayWindow.requestPermission();
      return granted ?? false;
    }
    return true;
  }

  @override
  Future<void> showOverlay() async {
    if (await FlutterOverlayWindow.isActive()) return;
    await FlutterOverlayWindow.showOverlay(
      enableDrag: false,
      overlayTitle: "ScreenTranslate AI",
      overlayContent: "Floating UI Active",
      // Important: Allow touch events to pass through so the user can interact with the app underneath
      flag: OverlayFlag.clickThrough, 
      visibility: NotificationVisibility.visibilityPrivate,
      alignment: OverlayAlignment.center,
      positionGravity: PositionGravity.none,
      width: WindowSize.matchParent,
      height: WindowSize.matchParent,
    );
  }

  @override
  Future<void> closeOverlay() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  @override
  Future<void> updateOverlayNodes(List<ExtractedTextNode> nodes) async {
    if (!(await FlutterOverlayWindow.isActive())) {
      await showOverlay();
    }
    // Serialize data to send across the isolate port
    final List<Map<String, dynamic>> payload = nodes.map((n) => n.toMap()).toList();
    await FlutterOverlayWindow.shareData(payload);
  }
}
