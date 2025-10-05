import 'dart:math';
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
import 'package:pro_dictant/features/trainings/presentation/pages/tw_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/answer_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import '../../../../core/ad_widget.dart';
import '../../domain/entities/dictant_training_entity.dart';
import '../../domain/entities/tw_training_entity.dart';
import '../manager/provider/combo_training_session.dart';
import 'combo_result_page.dart';
import 'dictant_in_process_page.dart';

class WTInProcessPage extends StatefulWidget {
  final String setId;
  final bool isCombo;
  const WTInProcessPage({
    super.key,
    required this.setId,
    this.isCombo = false,
  });

  @override
  State<WTInProcessPage> createState() => _WTInProcessPageState();
}

class _WTInProcessPageState extends State<WTInProcessPage> {
  int currentWordIndex = 0;
  Map<String, String> answers = {};
  final FlutterTts flutterTts = FlutterTts();
  var isPronounceSelected = false;
  late int correctSoundId;
  late int wrongSoundId;
  final Color _color = const Color(0xFF85977f);
  int numberOfAdsShown = 0;
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions());

  @override
  void initState() {
    getNumberOfAdsShown();
    initSounds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  final session = context.read<ComboTrainingSession>();
                  session.reset();
                  return Navigator.of(context).pop();
                },
                icon: Image.asset('assets/icons/cancel.png')),
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
              } else if (state is WTTrainingLoaded) {
                return _buildWordCard(state.words);
              } else {
                return const SizedBox();
              }
            },
          )),
    );
  }

  Widget _buildWordCard(List<WTTrainingEntity> words) {
    if (currentWordIndex >= words.length) return SizedBox();
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
          child: GestureDetector(
            onTap: () {
              speak(words[currentWordIndex].source);
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
        Flexible(
          flex: 2,
          child: Text(
            '${currentWordIndex + 1}/${words.length}',
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
          child: Text(
            words[currentWordIndex].source,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Flexible(
          flex: 4,
          child: Column(
            children: [
              ...buildSuggestedAnswers(words),
            ],
          ),
        )
      ],
    );
  }

  void updateCurrentWord(List<WTTrainingEntity> words) {
    if (currentWordIndex + 1 >= words.length) {
      if (widget.isCombo) {
        final session = context.read<ComboTrainingSession>();
        final wrongWordsFromPreviousTraining;
        if (session.correctAnswers['twTraining']!.toList().isEmpty &&
            session.twWrongAnswers.isEmpty) {
          final List<TWTrainingEntity> twWords = [];
          for (var word in words) {
            twWords.add(TWTrainingEntity(
                id: word.wordId,
                source: word.source,
                translation: word.translation));
          }
          twWords.shuffle();
          BlocProvider.of<TrainingsBloc>(context)
              .add(FetchWordsForTwTRainings(isCombo: true, words: twWords));
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => TWInProcessPage(
                    setId: widget.setId,
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
          final String wordSource = word.source;
          final String correctAnswer = word.translation;
          String? wrongAnswer;

          if (correctAnswer == value) {
            toUpdate.add(key);
          } else {
            wrongAnswer = value;
          }

          answersToSend.add((wordSource, correctAnswer, wrongAnswer));
        }

        BlocProvider.of<TrainingsBloc>(context)
            .add(UpdateWordsForWtTRainings(toUpdate));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) {
              final safeContext = ctx;
              return TrainingResultListPage(
                answers: answersToSend,
                onPressed: () {
                  final bloc = BlocProvider.of<TrainingsBloc>(safeContext);
                  if (widget.setId.isNotEmpty) {
                    bloc.add(FetchSetWordsForWtTRainings(widget.setId));
                    Navigator.of(safeContext).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => WTInProcessPage(
                              setId: widget.setId,
                            )));
                  } else {
                    bloc.add(const FetchWordsForWtTRainings());
                    Navigator.of(safeContext).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => const WTInProcessPage(
                              setId: '',
                            )));
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
    });
  }

  List<Widget> buildSuggestedAnswers(List<WTTrainingEntity> words) {
    if (currentWordIndex >= words.length) return [];
    List<Widget> answersContainers = [];
    final session = context.read<ComboTrainingSession>();
    var rng = Random();
    Set<int> randomSequence = {};
    do {
      randomSequence.add(rng.nextInt(4));
    } while (randomSequence.length < 4);

    for (var element in randomSequence) {
      element == 3
          ? answersContainers.add(Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: AnswerButton(
                      onPressed: () async {
                        answers[words[currentWordIndex].id] =
                            words[currentWordIndex].translation;
                        if (widget.isCombo) {
                          session.addCorrect("wtTraining", (
                            words[currentWordIndex].source,
                            words[currentWordIndex].translation,
                            words[currentWordIndex].id,
                          ));
                          session.removeWtWrong(words[currentWordIndex]);
                        }
                        await pool.play(correctSoundId);
                        updateCurrentWord(words);
                      },
                      text: words[currentWordIndex].translation,
                    )),
              ),
            ))
          : answersContainers.add(Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: AnswerButton(
                      onPressed: () async {
                        answers[words[currentWordIndex].id] =
                            words[currentWordIndex]
                                .suggestedTranslationList[element]
                                .translation;
                        if (widget.isCombo) {
                          session.addWtWrong(words[currentWordIndex]);
                        }
                        await pool.play(wrongSoundId);
                        updateCurrentWord(words);
                      },
                      text: words[currentWordIndex]
                          .suggestedTranslationList[element]
                          .translation,
                    )),
              ),
            ));
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

  Future<void> speak(String text) async {
    await flutterTts.setLanguage('en-GB');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  getNumberOfAdsShown() async {
    final prefs = await SharedPreferences.getInstance();
    numberOfAdsShown = prefs.getInt('numberOfAdsShown') ?? 0;
  }

  void initSounds() async {
    correctSoundId = await rootBundle
        .load("assets/sounds/correct.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    wrongSoundId = await rootBundle
        .load("assets/sounds/wrong.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
  }
}
