part of 'text_to_speech_cubit.dart';

class TextToSpeechState extends Equatable {
  const TextToSpeechState({
    this.textInput = '',
    this.parts = const [],
    this.currentPart = '',
    this.currentPartIndex = 0,
    // this.ttsSource = TtsSource.flowery,
    // this.ttsEngine = '',
    // this.language,
    this.ttsSource = TtsSource.native,
    this.ttsEngine = 'com.google.android.tts',
    this.language = 'en-US',
    this.voice = '',
    this.volume = 0.5,
    this.pitch = 1.0,
    this.rate = 0.5,
    this.progress = 0.0,
    this.ttsState = TtsState.stopped,
    this.isCurrentLanguageInstalled = false,
  });

  final String textInput;
  final List<String> parts;
  final String currentPart;
  final int currentPartIndex;
  final TtsSource ttsSource;
  final String ttsEngine;
  final String? language;
  final String voice;
  final double volume;
  final double pitch;
  final double rate;
  final double progress;
  final TtsState ttsState;
  final bool isCurrentLanguageInstalled;

  bool get isPlaying => ttsState == TtsState.playing;

  bool get isStopped => ttsState == TtsState.stopped;

  bool get isPaused => ttsState == TtsState.paused;

  bool get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWindows => !kIsWeb && Platform.isWindows;

  bool get isWeb => kIsWeb;

  @override
  List<Object?> get props => [
        textInput,
        parts,
        currentPart,
        currentPartIndex,
        ttsSource,
        ttsEngine,
        language,
        volume,
        pitch,
        rate,
        progress,
        ttsState,
        isCurrentLanguageInstalled,
      ];

  TextToSpeechState copyWith({
    String? textInput,
    List<String>? parts,
    String? currentPart,
    int? currentPartIndex,
    TtsSource? ttsSource,
    String? ttsEngine,
    String? language,
    String? voice,
    double? volume,
    double? pitch,
    double? rate,
    double? progress,
    TtsState? ttsState,
    bool? isCurrentLanguageInstalled,
  }) {
    return TextToSpeechState(
      textInput: textInput ?? this.textInput,
      parts: parts ?? this.parts,
      currentPart: currentPart ?? this.currentPart,
      currentPartIndex: currentPartIndex ?? this.currentPartIndex,
      ttsSource: ttsSource ?? this.ttsSource,
      ttsEngine: ttsEngine ?? this.ttsEngine,
      language: language ?? this.language,
      voice: voice ?? this.voice,
      volume: volume ?? this.volume,
      pitch: pitch ?? this.pitch,
      rate: rate ?? this.rate,
      progress: progress ?? this.progress,
      ttsState: ttsState ?? this.ttsState,
      isCurrentLanguageInstalled:
          isCurrentLanguageInstalled ?? this.isCurrentLanguageInstalled,
    );
  }

  TextToSpeechState copyWith2({
    String? textInput,
    List<String>? parts,
    String? currentPart,
    int? currentPartIndex,
    TtsSource? ttsSource,
    String? ttsEngine,
    String? language,
    String? voice,
    double? volume,
    double? pitch,
    double? rate,
    double? progress,
    TtsState? ttsState,
    bool? isCurrentLanguageInstalled,
  }) {
    return TextToSpeechState(
      textInput: textInput ?? this.textInput,
      parts: parts ?? this.parts,
      currentPart: currentPart ?? this.currentPart,
      currentPartIndex: currentPartIndex ?? this.currentPartIndex,
      ttsSource: ttsSource ?? this.ttsSource,
      ttsEngine: ttsEngine ?? this.ttsEngine,
      language: language,
      voice: voice ?? this.voice,
      volume: volume ?? this.volume,
      pitch: pitch ?? this.pitch,
      rate: rate ?? this.rate,
      progress: progress ?? this.progress,
      ttsState: ttsState ?? this.ttsState,
      isCurrentLanguageInstalled:
          isCurrentLanguageInstalled ?? this.isCurrentLanguageInstalled,
    );
  }

  @override
  String toString() {
    // return '''
    // TextToSpeechState {
    //   textInput: $textInput,
    //   parts: $parts,
    //   currentPart: $currentPart,
    //   currentPartIndex: $currentPartIndex,
    //   ttsSource: $ttsSource,
    //   ttsEngine: $ttsEngine,
    //   language: $language,
    //   voice: $voice,
    //   volume: $volume,
    //   pitch: $pitch,
    //   rate: $rate,
    //   progress: $progress,
    //   ttsState: $ttsState,
    //   isCurrentLanguageInstalled: $isCurrentLanguageInstalled,
    // }''';
    return '''
    TextToSpeechState {
      currentPartIndex: $currentPartIndex,
      ttsSource: $ttsSource,
      ttsEngine: $ttsEngine,
      language: $language,
      voice: $voice,
      volume: $volume,
      pitch: $pitch,
      rate: $rate,
      progress: $progress,
      ttsState: $ttsState,
      isCurrentLanguageInstalled: $isCurrentLanguageInstalled,
    }''';
  }
}
