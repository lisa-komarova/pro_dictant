import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_state.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/training_result_list_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/wt_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/animated_ answer_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yandex_mobileads/mobile_ads.dart';
import '../../../../core/ad_widget.dart';
import '../../../../core/platform/auto_speak_prefs.dart';
import '../../../../core/platform/sound_service.dart';
import '../../../../service_locator.dart';
import '../../domain/entities/dictant_training_entity.dart';
import '../../domain/entities/tw_training_entity.dart';
import '../manager/provider/combo_training_session.dart';
import 'combo_result_page.dart';
import 'dictant_in_process_page.dart';

class TWInProcessPage extends StatefulWidget {
  final String setId;
  final bool isCombo;

  const TWInProcessPage({
    super.key,
    required this.setId,
    this.isCombo = false,
  });

  @override
  State<TWInProcessPage> createState() => _TWInProcessPageState();
}

class _TWInProcessPageState extends State<TWInProcessPage> {
  int currentWordIndex = 0;
  Map<String, String> answers = {};
  List<int> answerOrder = [];
  int numberOfAdsShown = 0;
  late final correctSoundId;
  late final wrongSoundId;
  final soundService = sl.get<SoundService>();
  late FocusNode translationFocusNode;
  final FlutterTts flutterTts = FlutterTts();
  bool isAutoSpeakEnabled = false;
  final autoSpeakPrefs = sl.get<AutoSpeakPrefs>();

  @override
  void initState() {
    getNumberOfAdsShown();
    MobileAds.initialize();
    translationFocusNode = FocusNode();
    _loadAutoSpeak();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(translationFocusNode);
    });
    super.initState();
  }

  Future<void> _loadAutoSpeak() async {
    final value = await autoSpeakPrefs.getIsEnabled('TW');
    if (!mounted) return;
    setState(() {
      isAutoSpeakEnabled = value;
    });
  }

  @override
  void dispose() {
    translationFocusNode.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        isAutoSpeakEnabled = false;
        await flutterTts.stop();
        if (!didPop) {
          if (!widget.isCombo) Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () async {
                  await flutterTts.stop();
                  final session = context.read<ComboTrainingSession>();
                  session.reset();
                  return Navigator.of(context).pop();
                },
                icon: Semantics(
                  label: S.of(context).exitButton,
                  child: Image.asset('assets/icons/cancel.png'),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        isAutoSpeakEnabled = !isAutoSpeakEnabled;
                      });
                      autoSpeakPrefs.setIsEnabled('TW', isAutoSpeakEnabled);
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
                } else if (state is TWTrainingLoaded) {
                  return _buildWordCard(state.words);
                } else {
                  return const SizedBox();
                }
              },
            )),
      ),
    );
  }

  Widget _buildWordCard(List<TWTrainingEntity> words) {
    if (currentWordIndex >= words.length) return SizedBox();
    if (isAutoSpeakEnabled) speak(words[currentWordIndex].translation);
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
            '${currentWordIndex + 1}/${words.length}',
            semanticsLabel: S
                .of(context)
                .wordsRemaining(words.length - (currentWordIndex + 1)),
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
          flex: 2,
          child: Center(
            child: Semantics(
              child: Focus(
                focusNode: translationFocusNode,
                child: Semantics(
                  focused: translationFocusNode.hasFocus,
                  child: Text(
                    words[currentWordIndex].translation,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...buildSuggestedAnswers(words),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void updateCurrentWord(List<TWTrainingEntity> words) {
    if (currentWordIndex + 1 >= words.length) {
      if (widget.isCombo) {
        final session = context.read<ComboTrainingSession>();
        final wrongWordsFromPreviousTraining;
        if (session.correctAnswers['dictantTraining']!.toList().isEmpty &&
            session.dictantWrongAnswers.isEmpty) {
          final List<DictantTrainingEntity> dictantWords = [];
          for (var word in words) {
            dictantWords.add(DictantTrainingEntity(
                id: word.id,
                source: word.source,
                translation: word.translation));
          }
          dictantWords.shuffle();
          BlocProvider.of<TrainingsBloc>(context).add(
              FetchWordsForDictantTRainings(
                  isCombo: true, words: dictantWords));
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => DictantInProcessPage(
                    setId: widget.setId,
                    isCombo: true,
                  )));
          return;
        } else if (session.dictantWrongAnswers.toList().isNotEmpty) {
          wrongWordsFromPreviousTraining = session.dictantWrongAnswers.toList();
          wrongWordsFromPreviousTraining.shuffle();
          BlocProvider.of<TrainingsBloc>(context).add(
              FetchWordsForDictantTRainings(
                  words: wrongWordsFromPreviousTraining));
          session.resetDictantWrongAnswers();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => const DictantInProcessPage(
                    setId: '',
                    isCombo: true,
                  )));
          return;
        } else if (session.wtWrongAnswers.toList().isNotEmpty) {
          wrongWordsFromPreviousTraining = session.wtWrongAnswers.toList();
          wrongWordsFromPreviousTraining.shuffle();
          BlocProvider.of<TrainingsBloc>(context).add(
              FetchWordsForWtTRainings(words: wrongWordsFromPreviousTraining));
          session.resetWtWrongAnswers();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => const WTInProcessPage(
                    setId: '',
                    isCombo: true,
                  )));
          return;
        } else if (session.twWrongAnswers.toList().isNotEmpty) {
          wrongWordsFromPreviousTraining = session.twWrongAnswers.toList();
          wrongWordsFromPreviousTraining.shuffle();
          BlocProvider.of<TrainingsBloc>(context).add(
              FetchWordsForTwTRainings(words: wrongWordsFromPreviousTraining));
          session.resetTwWrongAnswers();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => const TWInProcessPage(
                    setId: '',
                    isCombo: true,
                  )));
          return;
        } else {
          final Set<(String, String)> allWordsSet = {};
          final List<WTTrainingEntity> wtInitialWrongAnswers =
              session.wtInitialWrongAnswers.toList();
          final List<TWTrainingEntity> twInitialWrongAnswers =
              session.twInitialWrongAnswers.toList();
          final List<DictantTrainingEntity> dictantInitialWrongAnswers =
              session.dictantInitialWrongAnswers.toList();

          for (var tuple in session.correctAnswers['wtTraining']!) {
            allWordsSet.add((tuple.$1, tuple.$2));
          }
          final String wtIdsToUpdate = session.correctAnswers["wtTraining"]!
              .where((item) => !wtInitialWrongAnswers.any((wrong) =>
                  wrong.source == item.$1 && wrong.translation == item.$2))
              .map((e) => "'${e.$3}'")
              .join(', ');
          final String twIdsToUpdate = session.correctAnswers["wtTraining"]!
              .where((item) => !twInitialWrongAnswers.any((wrong) =>
                  wrong.source == item.$1 && wrong.translation == item.$2))
              .map((e) => "'${e.$3}'")
              .join(', ');
          final String dictantIdsToUpdate = session
              .correctAnswers["wtTraining"]!
              .where((item) => !dictantInitialWrongAnswers.any((wrong) =>
                  wrong.source == item.$1 && wrong.translation == item.$2))
              .map((e) => "'${e.$3}'")
              .join(', ');
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => ComboResultPage(
                    allWords: allWordsSet.toList(),
                    twInitialWrongAnswers: twInitialWrongAnswers,
                    wtInitialWrongAnswers: wtInitialWrongAnswers,
                    dictantInitialWrongAnswers: dictantInitialWrongAnswers,
                  )));
          BlocProvider.of<TrainingsBloc>(context).add(
              UpdateWordsForComboTRainings(
                  wtIdstoUpdate: wtIdsToUpdate,
                  twIdstoUpdate: twIdsToUpdate,
                  dictantIdstoUpdate: dictantIdsToUpdate));
          session.reset();
          return;
        }
      } else {
        List<(String, String, String?)> answersToSend = [];
        List<String> toUpdate = [];

        for (var entry in answers.entries) {
          final key = entry.key;
          final value = entry.value;

          final word = words.firstWhere((element) => element.id == key);
          final String translation = word.translation;
          final String correctAnswer = word.source;
          String? wrongAnswer;

          if (correctAnswer == value) {
            toUpdate.add(key);
          } else {
            wrongAnswer = value;
          }

          answersToSend.add((translation, correctAnswer, wrongAnswer));
        }
        BlocProvider.of<TrainingsBloc>(context)
            .add(UpdateWordsForTwTRainings(toUpdate));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) {
              final safeContext = ctx;
              return TrainingResultListPage(
                answers: answersToSend,
                onPressed: () {
                  final bloc = BlocProvider.of<TrainingsBloc>(safeContext);

                  if (widget.setId.isNotEmpty) {
                    bloc.add(FetchSetWordsForTwTRainings(widget.setId));
                    Navigator.of(safeContext).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => TWInProcessPage(setId: widget.setId),
                      ),
                    );
                  } else {
                    bloc.add(const FetchWordsForTwTRainings());
                    Navigator.of(safeContext).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => const TWInProcessPage(setId: ''),
                      ),
                    );
                  }
                },
              );
            },
          ),
        );
        return;
      }
    }
    setState(() {
      currentWordIndex++;
      answerOrder = List.generate(4, (i) => i)..shuffle();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(translationFocusNode);
      }
    });
  }

  List<Widget> buildSuggestedAnswers(List<TWTrainingEntity> words) {
    if (currentWordIndex >= words.length) return [];
    List<Widget> answersContainers = [];
    if (answerOrder.isEmpty) {
      answerOrder = List.generate(4, (i) => i)..shuffle();
    }
    final order = answerOrder;
    final session = context.read<ComboTrainingSession>();

    for (var element in order) {
      element == 3
          ? answersContainers.add(Flexible(
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: AnimatedAnswerButton(
                  text: words[currentWordIndex].source,
                  locale: const Locale('en', 'GB'),
                  color: const Color(0xFF85977f),
                  onTap: () async {
                    answers[words[currentWordIndex].id] =
                        words[currentWordIndex].source;

                    if (widget.isCombo) {
                      session.addCorrect(
                        "twTraining",
                        (
                          words[currentWordIndex].source,
                          words[currentWordIndex].translation,
                          words[currentWordIndex].id,
                        ),
                      );
                      session.removeTwWrong(words[currentWordIndex]);
                    }

                    soundService.playCorrect();
                    updateCurrentWord(words);
                  },
                ),
              ),
            )))
          : answersContainers.add(Flexible(
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: AnimatedAnswerButton(
                  text: words[currentWordIndex]
                      .suggestedSourcesList[element]
                      .source,
                  locale: const Locale('en', 'GB'),
                  color: const Color(0xFFB70E0E),
                  onTap: () async {
                    answers[words[currentWordIndex].id] =
                        words[currentWordIndex]
                            .suggestedSourcesList[element]
                            .source;

                    if (widget.isCombo) {
                      session.addTwWrong(words[currentWordIndex]);
                    }

                    soundService.playWrong();
                    updateCurrentWord(words);
                  },
                ),
              ),
            )));
    }
    return answersContainers;
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  getNumberOfAdsShown() async {
    final prefs = await SharedPreferences.getInstance();
    numberOfAdsShown = prefs.getInt('numberOfAdsShown') ?? 0;
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage('ru');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text, focus: false);
  }
}
