import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/translation_service.dart';
import '../../domain/services/overlay_service.dart';
import '../../domain/services/accessibility_service.dart';
import '../../domain/services/screen_capture_service.dart';

// Services
final translationServiceProvider = Provider<TranslationRepository>((ref) {
  return GeminiTranslationRepository();
});

final overlayServiceProvider = Provider<OverlayService>((ref) {
  return FlutterOverlayService();
});

final accessibilityServiceProvider = Provider<AccessibilityService>((ref) {
  return AndroidAccessibilityService();
});

final screenCaptureServiceProvider = Provider<ScreenCaptureService>((ref) {
  return NativeScreenCaptureService();
});

// App State
class ServiceState {
  final bool isDaemonRunning;
  final bool isScreenCaptureActive;
  final bool isAccessibilityActive;
  final String sourceLanguage;
  final String targetLanguage;
  final String apiKey;

  ServiceState({
    this.isDaemonRunning = false,
    this.isScreenCaptureActive = false,
    this.isAccessibilityActive = false,
    this.sourceLanguage = 'ja', // Swapped default to match UI Japanese -> English
    this.targetLanguage = 'en',
    this.apiKey = 'AIzaSyAhVFOcK38Tvooa30o4AXFIxU0C_DcAqH8',
  });

  ServiceState copyWith({
    bool? isDaemonRunning,
    bool? isScreenCaptureActive,
    bool? isAccessibilityActive,
    String? sourceLanguage,
    String? targetLanguage,
    String? apiKey,
  }) {
    return ServiceState(
      isDaemonRunning: isDaemonRunning ?? this.isDaemonRunning,
      isScreenCaptureActive: isScreenCaptureActive ?? this.isScreenCaptureActive,
      isAccessibilityActive: isAccessibilityActive ?? this.isAccessibilityActive,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      apiKey: apiKey ?? this.apiKey,
    );
  }
}

class ServiceStateNotifier extends Notifier<ServiceState> {
  @override
  ServiceState build() {
    return ServiceState();
  }

  void toggleDaemon() {
    state = state.copyWith(isDaemonRunning: !state.isDaemonRunning);
  }

  void toggleScreenCapture() {
    state = state.copyWith(isScreenCaptureActive: !state.isScreenCaptureActive);
  }

  void toggleAccessibility() {
    state = state.copyWith(isAccessibilityActive: !state.isAccessibilityActive);
  }

  void setApiKey(String key) {
    state = state.copyWith(apiKey: key);
  }

  void swapLanguages() {
    final temp = state.sourceLanguage;
    state = state.copyWith(sourceLanguage: state.targetLanguage, targetLanguage: temp);
  }

  void setSourceLanguage(String lang) {
    state = state.copyWith(sourceLanguage: lang);
  }

  void setTargetLanguage(String lang) {
    state = state.copyWith(targetLanguage: lang);
  }
}

final serviceStateProvider = NotifierProvider<ServiceStateNotifier, ServiceState>(() {
  return ServiceStateNotifier();
});
