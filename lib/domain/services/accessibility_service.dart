import '../models/translation_models.dart';

abstract class AccessibilityService {
  Future<bool> requestAccessibilityPermission();
  Future<bool> isAccessibilityGranted();
  Stream<List<ExtractedTextNode>> get textNodesStream;
  Future<void> startService();
  Future<void> stopService();
}

class AndroidAccessibilityService implements AccessibilityService {
  @override
  Future<bool> requestAccessibilityPermission() async {
    // TODO: Implement using flutter_accessibility_service
    return true;
  }

  @override
  Future<bool> isAccessibilityGranted() async {
    // TODO: Implement using flutter_accessibility_service
    return true;
  }

  @override
  Stream<List<ExtractedTextNode>> get textNodesStream => const Stream.empty(); // TODO

  @override
  Future<void> startService() async {
    // TODO
  }

  @override
  Future<void> stopService() async {
    // TODO
  }
}
