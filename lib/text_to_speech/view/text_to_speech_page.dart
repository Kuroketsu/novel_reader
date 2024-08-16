import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flowery_tts/flowery_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novel_reader/common/helper/helpers.dart';
import 'package:novel_reader/gen/colors.gen.dart';
import 'package:novel_reader/l10n/l10n.dart';
import 'package:novel_reader/text_to_speech/util/text_to_speech_utils.dart';
import 'package:path_provider/path_provider.dart';

@RoutePage()
class TextToSpeechPage extends StatefulWidget {
  const TextToSpeechPage({super.key});

  @override
  State<TextToSpeechPage> createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {
  bool isPlaying = false;

  TextToSpeechEngine textToSpeechEngine = TextToSpeechEngine.device;

  final TextEditingController textInputController = TextEditingController();
  final TextEditingController highlightTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final assetsAudioPlayer = AssetsAudioPlayer();

  final Flowery flowery = const Flowery(
    userAgent: 'Kuroketsu/Novel Reader/1.0.0',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black87,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              padding: const EdgeInsets.all(8),
              child: RawScrollbar(
                thumbVisibility: true,
                thickness: 4,
                controller: scrollController,
                thumbColor: Colors.white,
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                  controller: textInputController,
                  scrollController: scrollController,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isPlaying ? null : textInputController.clear,
                child: const Icon(Icons.clear),
              ),
              ElevatedButton(
                onPressed: isPlaying
                    ? null
                    : () async {
                        textInputController.text = textInputController.text +
                            await _getClipboardText();
                      },
                child: const Icon(Icons.paste),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                  });

                  if (isPlaying) {
                    _play();
                  } else {
                    _pause();
                  }
                },
                child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              ),
              ElevatedButton(
                onPressed: isPlaying
                    ? () {
                        setState(() {
                          isPlaying = false;
                        });
                        _stop();
                      }
                    : null,
                child: const Icon(Icons.stop),
              ),
              Visibility(
                visible: false,
                child: ElevatedButton(
                  onPressed: isPlaying ? null : _showSettingsDialog,
                  child: const Icon(Icons.settings),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> _getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    return clipboardData?.text ?? '';
  }

  Future<void> _play() async {
    if (textInputController.text.isEmpty) return;

    final text = textInputController.text;

    final parts = TextToSpeechUtils.textToParts(text);

    final audioFiles = await _getAudioFiles(parts);

    final playlist = await _getPlaylist(audioFiles);

    await assetsAudioPlayer.open(playlist);
    await assetsAudioPlayer.play();
  }

  Future<List<String>> _getAudioFiles(List<String> parts) async {
    final directory = await getApplicationDocumentsDirectory();

    final audioFiles = List<String>.empty(growable: true);
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      debugPrint('_getAudioFiles part $i: $part');
      final audio = await flowery.tts(
        text: part,
        voice: 'Anna',
      );

      final file = File('${directory.path}/part$i.mp3')
        ..writeAsBytesSync(audio);
      audioFiles.add(file.absolute.path);
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

  Future<void> _pause() async {
    await assetsAudioPlayer.pause();
  }

  Future<void> _stop() async {
    await assetsAudioPlayer.stop();
  }

  Future<void> _showSettingsDialog() async {
    final l10n = context.l10n;
    final ttsEngineList = [
      TextToSpeechEngine.device.name,
      TextToSpeechEngine.flowery.name,
    ];

    var selectedTTSEngine = textToSpeechEngine;

    Helpers.showCustomContentGenericDialog(
      parentContext: context,
      title: l10n.settings,
      backgroundColor: ColorName.primaryColor,
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Text(l10n.textToSpeechEngine),
              DropdownButton<String>(
                items: ttsEngineList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                value: selectedTTSEngine.name,
                onChanged: (value) {
                  if (value == TextToSpeechEngine.device.name) {
                    setState(() {
                      selectedTTSEngine = TextToSpeechEngine.device;
                    });
                  } else {
                    setState(() {
                      selectedTTSEngine = TextToSpeechEngine.flowery;
                    });
                  }
                },
              ),
            ],
          );
        },
      ),
      positiveButtonText: l10n.save,
      positiveCallback: () {
        setState(() {
          textToSpeechEngine = selectedTTSEngine;
        });
      },
      negativeButtonText: l10n.cancel,
    );
  }
}
