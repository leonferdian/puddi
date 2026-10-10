import 'package:flutter/services.dart';
import '../models/translation_models.dart';

abstract class ScreenCaptureService {
  Future<bool> requestScreenCapturePermission();
  Future<void> startCapture();
  Future<void> stopCapture();
  Stream<List<ExtractedTextNode>> get ocrTextNodesStream;
}

class NativeScreenCaptureService implements ScreenCaptureService {
  static const MethodChannel _channel = MethodChannel('com.example.puddi/screen_capture');
  static const EventChannel _eventChannel = EventChannel('com.example.puddi/ocr_events');

  @override
  Future<bool> requestScreenCapturePermission() async {
    try {
      final bool? result = await _channel.invokeMethod('requestPermission');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> startCapture() async {
    await _channel.invokeMethod('startCapture');
  }

  @override
  Future<void> stopCapture() async {
    await _channel.invokeMethod('stopCapture');
  }

  @override
  Stream<List<ExtractedTextNode>> get ocrTextNodesStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      if (event is List) {
        return event.map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          return ExtractedTextNode(
            text: map['text'] as String,
            boundingBox: Rect.fromLTRB(
              (map['left'] as num).toDouble(),
              (map['top'] as num).toDouble(),
              (map['right'] as num).toDouble(),
              (map['bottom'] as num).toDouble(),
            ),
          );
        }).toList();
      }
      return [];
    });
  }
}
