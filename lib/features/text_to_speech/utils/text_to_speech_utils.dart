class TextToSpeechUtils {

  static List<String> textToParts(String text, {int maxLength = 2048}) {
    if (text.length <= maxLength) {
      return [text];
    }

    final parts = List<String>.empty(growable: true);
    final paragraphGroup = List<String>.empty(growable: true);
    final paragraphs = text.split('\n');

    for (var i = 0; i < paragraphs.length; i++) {
      final paragraph = paragraphs[i];
      if (paragraph.trim().isNotEmpty &&
          paragraph.length <= maxLength) {
        if ((paragraphGroup.join('\n').length + paragraph.length) <=
            maxLength) {
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
          if (sentence.trim().isNotEmpty &&
              sentence.length <= maxLength) {
            if ((sentenceGroup.join('. ').length + sentence.length) <=
                maxLength) {
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

enum TtsSource { native, flowery }

enum TtsState { playing, stopped, paused, continued }
