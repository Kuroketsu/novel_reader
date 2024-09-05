import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novel_reader/common/helper/helpers.dart';
import 'package:novel_reader/gen/colors.gen.dart';
import 'package:novel_reader/l10n/l10n.dart';
import 'package:novel_reader/features/text_to_speech/bloc/text_to_speech_cubit.dart';
import 'package:novel_reader/features/text_to_speech/util/text_to_speech_utils.dart';
import 'package:search_highlight_text/search_highlight_text.dart';

@RoutePage()
class TextToSpeechPage extends StatelessWidget {
  const TextToSpeechPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TextToSpeechCubit(),
      child: const TextToSpeechView(),
    );
  }
}

class TextToSpeechView extends StatefulWidget {
  const TextToSpeechView({super.key});

  @override
  State<TextToSpeechView> createState() => _TextToSpeechViewState();
}

class _TextToSpeechViewState extends State<TextToSpeechView> {
  final TextEditingController textInputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(
    List<dynamic> engines,
  ) {
    final items = <DropdownMenuItem<String>>[];
    for (final dynamic type in engines) {
      items.add(
        DropdownMenuItem(
          value: type as String?,
          child: Text(type!),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
    List<dynamic> languages,
  ) {
    final items = <DropdownMenuItem<String>>[];
    for (final dynamic type in languages) {
      items.add(
        DropdownMenuItem(
          value: type as String?,
          child: Text(type!),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    textInputController.addListener(() {
      context
          .read<TextToSpeechCubit>()
          .changeInputText(textInputController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextToSpeechCubit, TextToSpeechState>(
      builder: (context, state) {
        final cubit = context.read<TextToSpeechCubit>();
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black87
              : Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: RawScrollbar(
                    thumbVisibility: true,
                    thickness: 4,
                    controller: scrollController,
                    thumbColor: Colors.white,
                    child: state.isPlaying
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: SingleChildScrollView(
                              child: SearchHighlightText(
                                state.textInput,
                                searchText: state.currentPart,
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                                highlightStyle: const TextStyle(
                                  fontSize: 22,
                                  backgroundColor: Colors.white,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            controller: textInputController,
                            scrollController: scrollController,
                            maxLines: null,
                            expands: true,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: state.progress,
                // value: 0.5,
                color: Theme.of(context).canvasColor,
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        state.isPlaying ? null : textInputController.clear,
                    child: const Icon(Icons.clear),
                  ),
                  ElevatedButton(
                    onPressed: state.isPlaying
                        ? null
                        : () async {
                            textInputController.text =
                                textInputController.text +
                                    await cubit.getClipboardText();
                          },
                    child: const Icon(Icons.paste),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (state.isPlaying) {
                        cubit.pause();
                      } else {
                        cubit.play();
                      }
                    },
                    child:
                        Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                  ElevatedButton(
                    onPressed:
                        state.isPlaying || state.isPaused ? cubit.stop : null,
                    child: const Icon(Icons.stop),
                  ),
                  ElevatedButton(
                    onPressed: state.isPlaying
                        ? null
                        : () => _showSettingsDialog(cubit),
                    child: const Icon(Icons.settings),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSettingsDialog(TextToSpeechCubit cubit) async {
    final l10n = context.l10n;

    Helpers.showCustomContentGenericDialog(
      parentContext: context,
      title: l10n.settings,
      backgroundColor: ColorName.primaryColor,
      content: Column(
        children: [
          _ttsSourceSection(cubit),
          if (cubit.state.ttsSource == TtsSource.native) ...[
            _engineSection(cubit),
            _languageSection(cubit),
            _buildSliders(cubit),
          ],
          // if(cubit.state.ttsSource == TtsSource.flowery)
          //   _voiceSection(cubit),
        ],
      ),
      positiveButtonText: l10n.done,
    );
  }

  Widget _ttsSourceSection(TextToSpeechCubit cubit) {
    final l10n = context.l10n;
    final ttsEngineList = [
      TtsSource.native.name,
      TtsSource.flowery.name,
    ];

    var selectedTtsSource = cubit.state.ttsSource;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Text(l10n.textToSpeechSource),
            DropdownButton<String>(
              items: ttsEngineList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              value: selectedTtsSource.name,
              onChanged: (value) {
                if (value == TtsSource.native.name) {
                  setState(() {
                    selectedTtsSource = TtsSource.native;
                  });
                  cubit.changeTtsSource(selectedTtsSource);
                } else {
                  setState(() {
                    selectedTtsSource = TtsSource.flowery;
                  });
                  cubit.changeTtsSource(selectedTtsSource);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _engineSection(TextToSpeechCubit cubit) {
    if (cubit.state.isAndroid) {
      return FutureBuilder<dynamic>(
        future: cubit.getEngines(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            debugPrint('_engineSection: ${snapshot.data}');
            return _enginesDropDownSection(
              cubit,
              snapshot.data as List<dynamic>,
            );
          } else if (snapshot.hasError) {
            return const Text('Error loading engines...');
          } else {
            return const Text('Loading engines...');
          }
        },
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _languageSection(TextToSpeechCubit cubit) {
    return FutureBuilder<dynamic>(
      future: cubit.getLanguages(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          debugPrint('_languageSection: ${snapshot.data}');
          return _languageDropDownSection(
            cubit,
            snapshot.data as List<dynamic>,
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading languages...');
        } else {
          return const Text('Loading Languages...');
        }
      },
    );
  }

  Widget _enginesDropDownSection(
    TextToSpeechCubit cubit,
    List<dynamic> engines,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: DropdownButton(
        value: cubit.state.ttsEngine.isEmpty ? null : cubit.state.ttsEngine,
        items: getEnginesDropDownMenuItems(engines),
        onChanged: cubit.changedEnginesDropDownItem,
      ),
    );
  }

  Widget _languageDropDownSection(
    TextToSpeechCubit cubit,
    List<dynamic> languages,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(
            value: cubit.state.language == null || cubit.state.language!.isEmpty
                ? null
                : cubit.state.language,
            items: getLanguageDropDownMenuItems(languages),
            onChanged: cubit.changedLanguageDropDownItem,
          ),
          Visibility(
            visible: cubit.state.isAndroid,
            child:
                Text('Is installed: ${cubit.state.isCurrentLanguageInstalled}'),
          ),
        ],
      ),
    );
  }

  Widget _buildSliders(TextToSpeechCubit cubit) {
    return Column(
      children: [_volume(cubit), _pitch(cubit), _rate(cubit)],
    );
  }

  Widget _volume(TextToSpeechCubit cubit) {
    return Slider(
      value: cubit.state.volume,
      onChanged: (newVolume) {
        cubit.changeVolume(newVolume);
      },
      divisions: 10,
      label: 'Volume: ${cubit.state.volume}',
      activeColor: Colors.blue,
    );
  }

  Widget _pitch(TextToSpeechCubit cubit) {
    return Slider(
      value: cubit.state.pitch,
      onChanged: (newPitch) {
        cubit.changePitch(newPitch);
      },
      min: 0.5,
      max: 2,
      divisions: 15,
      label: 'Pitch: ${cubit.state.pitch}',
      activeColor: Colors.red,
    );
  }

  Widget _rate(TextToSpeechCubit cubit) {
    return Slider(
      value: cubit.state.rate,
      onChanged: (newRate) {
        cubit.changeRate(newRate);
      },
      divisions: 10,
      label: 'Rate: ${cubit.state.rate}',
      activeColor: Colors.green,
    );
  }
}
