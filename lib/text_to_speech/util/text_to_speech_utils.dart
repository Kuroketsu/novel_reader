class TextToSpeechUtils {
  static const ttsMaxLength = 2048;

  static List<String> textToParts(String text) {
    if (text.length <= ttsMaxLength) {
      return [text];
    }

    final parts = List<String>.empty(growable: true);
    final paragraphGroup = List<String>.empty(growable: true);
    final paragraphs = text.split('\n');

    for (var i = 0; i < paragraphs.length; i++) {
      final paragraph = paragraphs[i];
      if (paragraph.trim().isNotEmpty && paragraph.length <= ttsMaxLength) {
        if ((paragraphGroup.join('\n').length + paragraph.length) <=
            ttsMaxLength) {
          paragraphGroup.add(paragraph);
          if (i == paragraphs.length - 1) {
            parts.add(paragraphGroup.join('\n'));
          }
        } else {
          parts.add(paragraphGroup.join('\n'));
          paragraphGroup
            ..clear()
            ..add(paragraph);
        }
      } else {
        final sentenceGroup = List<String>.empty(growable: true);
        final sentences = paragraph.split('.');
        for (final sentence in sentences) {
          if (sentence.trim().isNotEmpty && sentence.length <= ttsMaxLength) {
            if ((sentenceGroup.join('. ').length + sentence.length) <=
                ttsMaxLength) {
              sentenceGroup.add(sentence);
            } else {
              parts.add(sentenceGroup.join('. '));
              sentenceGroup
                ..clear()
                ..add(sentence);
            }
          }
        }
      }
    }
    return parts;
  }
}

enum TextToSpeechEngine { device, flowery }
