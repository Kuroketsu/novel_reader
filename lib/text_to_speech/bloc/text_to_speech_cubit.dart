import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowery_tts/flowery_tts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:novel_reader/text_to_speech/util/text_to_speech_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';

part 'text_to_speech_state.dart';

class TextToSpeechCubit extends Cubit<TextToSpeechState> {
  TextToSpeechCubit()
      : flutterTts = FlutterTts(),
        flowery = const Flowery(
          userAgent: 'Kuroketsu/Novel Reader/1.0.0',
        ),
        assetsAudioPlayer = AssetsAudioPlayer(),
        super(const TextToSpeechState()) {
    initTts();
  }

  @override
  Future<void> close() {
    flutterTts.stop();
    return super.close();
  }

  final FlutterTts flutterTts;

  final Flowery flowery;

  final AssetsAudioPlayer assetsAudioPlayer;

  void initTts() {
    _setAwaitOptions();

    if (state.isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts
      ..setStartHandler(() {
        debugPrint('Playing');
        emit(state.copyWith(ttsState: TtsState.playing));
      })
      ..setCompletionHandler(() {
        debugPrint('Complete');
        emit(state.copyWith(ttsState: TtsState.stopped));
      })
      ..setCancelHandler(() {
        debugPrint('Cancel');
        emit(state.copyWith(ttsState: TtsState.stopped));
      })
      ..setPauseHandler(() {
        debugPrint('Paused');
        emit(state.copyWith(ttsState: TtsState.paused));
      })
      ..setContinueHandler(() {
        debugPrint('Continued');
        emit(state.copyWith(ttsState: TtsState.continued));
      })
      ..setErrorHandler((msg) {
        debugPrint('error: $msg');
        emit(state.copyWith(ttsState: TtsState.stopped));
      });
  }

  Future<dynamic> getLanguages() async => flutterTts.getLanguages;

  Future<dynamic> getEngines() async => flutterTts.getEngines;

  Future<void> _getDefaultEngine() async {
    final engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      debugPrint(engine.toString());
    }
  }

  Future<void> _getDefaultVoice() async {
    final voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      debugPrint(voice.toString());
    }
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  void changeInputText(String text) {
    emit(state.copyWith(textInput: text));
  }

  Future<void> play() async {
    if (state.textInput.isEmpty) return;

    if (state.ttsSource == TtsSource.flowery) {
      final parts = TextToSpeechUtils.textToParts(state.textInput);
      emit(
        state.copyWith(
          parts: parts,
          currentPartIndex: 0,
          currentPart: '',
        ),
      );

      final audioFiles = await _getAudioFiles(parts);

      if (audioFiles.isEmpty) {
        emit(state.copyWith(ttsState: TtsState.stopped));
        return;
      }

      final playlist = await _getPlaylist(audioFiles);

      await assetsAudioPlayer.open(playlist);
      await assetsAudioPlayer.play();

      emit(state.copyWith(ttsState: TtsState.playing));

      assetsAudioPlayer.current.listen((Playing? playing) {
        final path = playing!.audio.assetAudioPath;
        final index = audioFiles.indexOf(path);
        emit(
          state.copyWith(
            currentPartIndex: index,
            currentPart: parts[index],
            progress: (state.currentPartIndex + 1) / state.parts.length,
          ),
        );
      });
    } else {
      await flutterTts.setVolume(state.volume);
      await flutterTts.setSpeechRate(state.rate);
      await flutterTts.setPitch(state.pitch);

      final maxInputLength = await flutterTts.getMaxSpeechInputLength;
      debugPrint('flutterTts maxLength: $maxInputLength');

      final parts = TextToSpeechUtils.textToParts(state.textInput);
      emit(
        state.copyWith(
          parts: parts,
          currentPartIndex: 0,
          currentPart: '',
        ),
      );

      emit(state.copyWith(ttsState: TtsState.playing));

      if (state.textInput.isNotEmpty) {
        for (var i = 0; i < parts.length; i++) {
          final part = parts[i];
          emit(
            state.copyWith(
              currentPartIndex: i,
              currentPart: part,
              progress: (i + 1) / state.parts.length,
            ),
          );

          if (state.ttsState == TtsState.playing) {
            await flutterTts.speak(part);
          }
        }
      }
    }
  }

  Future<void> stop() async {
    if (state.ttsSource == TtsSource.flowery) {
      await assetsAudioPlayer.stop();
      emit(state.copyWith(ttsState: TtsState.stopped));
    } else {
      final result = await flutterTts.stop();
      if (result == 1) emit(state.copyWith(ttsState: TtsState.stopped));
    }
  }

  Future<void> pause() async {
    if (state.ttsSource == TtsSource.flowery) {
      await assetsAudioPlayer.pause();
      emit(state.copyWith(ttsState: TtsState.paused));
    } else {
      final result = await flutterTts.pause();
      if (result == 1) emit(state.copyWith(ttsState: TtsState.paused));
    }
  }

  Future<List<String>> _getAudioFiles(List<String> parts) async {
    final directory = await getApplicationDocumentsDirectory();

    final audioFiles = List<String>.empty(growable: true);
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      debugPrint('_getAudioFiles part $i: $part');
      Uint8List? audio;
      try {
        audio = await flowery.tts(
          text: part,
          voice: 'Anna',
        );
      } on FloweryException catch (e) {
        debugPrint(e.error);
        Toastification().show(
          title: Text(e.error),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 10),
        );
      } catch (e) {
        debugPrint(e.toString());
        Toastification().show(
          title: Text(e.toString()),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 10),
        );
      }

      if (audio == null) {
        return [];
      }

      final file = File('${directory.path}/part$i.mp3')
        ..writeAsBytesSync(audio);
      audioFiles.add(file.absolute.path);

      emit(
        state.copyWith(
          progress: (i + 1) / state.parts.length,
        ),
      );
    }

    return audioFiles;
  }

  Future<Playlist> _getPlaylist(List<String> audioFiles) async {
    final playlist = Playlist(
      audios: [
        for (final audioFile in audioFiles) Audio.file(audioFile),
      ],
    );
    return playlist;
  }

  Future<String> getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text ?? '';
    // emit(state.copyWith(textInput: text));
    return text;
  }

  void changeTtsSource(TtsSource ttsSource) {
    emit(state.copyWith(ttsSource: ttsSource));
  }

  void changeVolume(double volume) {
    emit(state.copyWith(volume: volume));
  }

  void changeRate(double rate) {
    emit(state.copyWith(rate: rate));
  }

  void changePitch(double pitch) {
    emit(state.copyWith(pitch: pitch));
  }

  Future<void> changedEnginesDropDownItem(String? selectedEngine) async {
    await flutterTts.setEngine(selectedEngine!);
    emit(
      state.copyWith2(
        ttsEngine: selectedEngine,
      ),
    );
  }

  Future<void> changedLanguageDropDownItem(String? selectedType) async {
    emit(
      state.copyWith(
        language: selectedType,
      ),
    );
    await flutterTts.setLanguage(state.language!);
    if (state.isAndroid) {
      final isCurrentLanguageInstalled =
          await flutterTts.isLanguageInstalled(state.language!) as bool;
      emit(
        state.copyWith(isCurrentLanguageInstalled: isCurrentLanguageInstalled),
      );
    }
  }
}
