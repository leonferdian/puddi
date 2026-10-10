import 'dart:ui';

class ExtractedTextNode {
  final String text;
  final Rect boundingBox;
  final String? translatedText;

  ExtractedTextNode({
    required this.text,
    required this.boundingBox,
    this.translatedText,
  });

  ExtractedTextNode copyWith({
    String? text,
    Rect? boundingBox,
    String? translatedText,
  }) {
    return ExtractedTextNode(
      text: text ?? this.text,
      boundingBox: boundingBox ?? this.boundingBox,
      translatedText: translatedText ?? this.translatedText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'left': boundingBox.left,
      'top': boundingBox.top,
      'right': boundingBox.right,
      'bottom': boundingBox.bottom,
      'translatedText': translatedText,
    };
  }

  factory ExtractedTextNode.fromMap(Map<String, dynamic> map) {
    return ExtractedTextNode(
      text: map['text'],
      boundingBox: Rect.fromLTRB(
        (map['left'] as num).toDouble(),
        (map['top'] as num).toDouble(),
        (map['right'] as num).toDouble(),
        (map['bottom'] as num).toDouble(),
      ),
      translatedText: map['translatedText'],
    );
  }
}
