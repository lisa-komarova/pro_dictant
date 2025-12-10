import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/wt_in_process_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/ad_widget.dart';
import '../../../../core/platform/auto_speak_prefs.dart';
import '../../../../core/platform/sound_service.dart';
import '../../../../service_locator.dart';
import '../../domain/entities/combo_training_entity.dart';
import '../../domain/entities/wt_training_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';

class ComboInitialPage extends StatefulWidget {
  const ComboInitialPage({
    super.key,
  });

  @override
  State<ComboInitialPage> createState() => _ComboInitialPageState();
}

class _ComboInitialPageState extends State<ComboInitialPage> {
  int currentWordIndex = 0;
  final FlutterTts flutterTts = FlutterTts();
  var isPronounceSelected = false;
  final Color _color = const Color(0xFF85977f);
  int numberOfAdsShown = 0;
  final List<ComboTrainingEntity> wordsToLearn = [];
  final soundService = sl.get<SoundService>();
  late FocusNode sourceFocusNode;
  bool isAutoSpeakEnabled = false;
  final autoSpeakPrefs = sl.get<AutoSpeakPrefs>();

  @override
  void initState() {
    getNumberOfAdsShown();
    sourceFocusNode = FocusNode();
    _loadAutoSpeak();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(sourceFocusNode);
    });
    super.initState();
  }

  Future<void> _loadAutoSpeak() async {
    isAutoSpeakEnabled = await autoSpeakPrefs.getIsEnabled('ComboInit');
  }

  @override
  void dispose() {
    flutterTts.stop();
    sourceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if(!soundService.isInitialized || !soundService.soundsAreInitialized ) return _loadingIndicator();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        isAutoSpeakEnabled = false;
        await flutterTts.stop();
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () async {
                  await flutterTts.stop();
                  return Navigator.of(context).pop();
                },
                icon: Semantics(
                    label: S.of(context).exitButton,
                    child: Image.asset('assets/icons/cancel.png'))),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isAutoSpeakEnabled = !isAutoSpeakEnabled;
                    });
                    autoSpeakPrefs.setIsEnabled("ComboInit", isAutoSpeakEnabled);
                  },
                  icon: Semantics(
                      label: isAutoSpeakEnabled
                          ? S.of(context).turnAutoSpeakOff
                          : S.of(context).turnAutoSpeakOn,
                      child: isAutoSpeakEnabled
                          ? Image.asset(
                              'assets/icons/announce_word_activated.png')
                          : Image.asset(
                              'assets/icons/announce_word_not_activated.png')))
            ],
          ),
          body: BlocBuilder<TrainingsBloc, TrainingsState>(
            builder: (context, state) {
              if (state is TrainingEmpty) {
                return Center(
                  child: Text(
                    S.of(context).notEnoughWords,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is TrainingLoading) {
                return _loadingIndicator();
              } else if (state is ComboTrainingLoaded) {
                return _buildWordCard(state.words);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildWordCard(List<ComboTrainingEntity> words) {
    if (currentWordIndex >= words.length || wordsToLearn.length >= 5)
      return SizedBox();
    if (isAutoSpeakEnabled) {
      speak(
        words[currentWordIndex].source,
        words[currentWordIndex].translation,
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              child: numberOfAdsShown < 3
                  ? BannerAdvertisement(
                      screenWidth: MediaQuery.of(context).size.width.round(),
                    )
                  : null,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Text(
            '${wordsToLearn.length + 1}/${words.length >= 5 ? 5 : words.length}',
            semanticsLabel:
                S.of(context).wordsRemaining(5 - wordsToLearn.length),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Flexible(
          flex: 1,
          child: SizedBox(
            height: 100,
          ),
        ),
        Flexible(
          child: ExcludeSemantics(
            child: GestureDetector(
              onTap: () {
                speak(
                  words[currentWordIndex].source,
                  words[currentWordIndex].translation,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Image.asset(
                  'assets/icons/pronounce.png',
                  width: 80,
                  height: 80,
                  color: _color,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Focus(
                    focusNode: sourceFocusNode,
                    child: Semantics(
                      focused: sourceFocusNode.hasFocus,
                      child: Text(
                        words[currentWordIndex].source,
                        locale: Locale('en_GB'),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        words[currentWordIndex].translation,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: FilledButton(
                      onPressed: () async {
                        if (currentWordIndex + 1 >= words.length) {
                          finishWorkout(wordsToLearn);
                          return;
                        }
                        await soundService.playNeutral();
                        setState(() {
                          currentWordIndex++;
                        });
                        if (wordsToLearn.length >= 5) {
                          finishWorkout(wordsToLearn);
                          return;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFd9c3ac),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AutoSizeText(
                              S.of(context).pass,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: FilledButton(
                      onPressed: () async {
                        wordsToLearn.add(words[currentWordIndex]);
                        await soundService.playCorrect();
                        Future.delayed(Duration(milliseconds: 100));
                        if (currentWordIndex + 1 >= words.length) {
                          finishWorkout(wordsToLearn);
                          return;
                        }
                        setState(() {
                          currentWordIndex++;
                        });
                        if (wordsToLearn.length >= 5) {
                          finishWorkout(wordsToLearn);
                          return;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFd9c3ac),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AutoSizeText(
                              S.of(context).learn,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Flexible(
          flex: 1,
          child: SizedBox(
            height: 100,
          ),
        ),
      ],
    );
  }

  void finishWorkout(List<ComboTrainingEntity> wordsToLearn) {
    final List<WTTrainingEntity> wtWords = [];
    for (var word in wordsToLearn) {
      wtWords.add(WTTrainingEntity(
          id: word.id,
          wordId: word.wordId,
          source: word.source,
          translation: word.translation));
    }
    wtWords.shuffle();

    BlocProvider.of<TrainingsBloc>(context)
        .add(FetchWordsForWtTRainings(words: wtWords));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const WTInProcessPage(
              setId: '',
              isCombo: true,
            )));
  }

  Future<void> speak(String source, String translation) async {
    await flutterTts.setLanguage('en-GB');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(source, focus: false);
    await _waitForTtsCompletion();
    await flutterTts.setLanguage('ru');
    await flutterTts.speak(translation, focus: false);
  }

  Future<void> _waitForTtsCompletion() async {
    Completer<void> completer = Completer();

    flutterTts.setCompletionHandler(() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    return completer.future;
  }

  getNumberOfAdsShown() async {
    final prefs = await SharedPreferences.getInstance();
    numberOfAdsShown = prefs.getInt('numberOfAdsShown') ?? 0;
  }
}
