import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/domain/entities/matching_training_entity.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_state.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/training_result_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import '../../../../core/ad_widget.dart';
import 'matching_result_page.dart';

class MatchingInProcessPage extends StatefulWidget {
  final String setId;

  const MatchingInProcessPage({
    super.key,
    required this.setId,
  });

  @override
  State<MatchingInProcessPage> createState() => _MatchingInProcessPageState();
}

class _MatchingInProcessPageState extends State<MatchingInProcessPage> {
  bool isWordChosen = false;
  bool isTranslationChosen = false;
  bool isWordChosenWrong = false;
  bool isTranslationChosenWrong = false;
  List<MatchingTrainingEntity> currentAnswer = [];
  List<MatchingTrainingEntity> correctAnswers = [];
  List<int> availableIndexes = [];
  List<Color> colors = [
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF),
  ];
  List<MatchingTrainingEntity> wordsList = [];
  List<MatchingTrainingEntity> currentWordsList = [];
  List<MatchingTrainingEntity> currentTranslationList = [];
  List<
      (
        MatchingTrainingEntity word,
        List<String> wrongChoices,
        bool isSourceChosen
      )> mistakes = [];
  int numberOfAdsShown = 0;
  late int correctSoundId;
  late int wrongSoundId;
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions());

  @override
  void initState() {
    getNumberOfAdsShown();
    initSounds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
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
            } else if (state is MatchingTrainingLoaded) {
              if (wordsList.isEmpty && correctAnswers.isEmpty) {
                wordsList.addAll(state.words);
                if (wordsList.length >= 5) {
                  wordsList.removeRange(0, 5);
                } else {
                  wordsList.clear();
                }
              }
              if (currentWordsList.isEmpty) {
                if (state.words.length >= 5) {
                  currentWordsList.addAll(state.words.getRange(0, 5));
                } else {
                  currentWordsList.addAll(state.words);
                }
              }
              if (currentTranslationList.isEmpty) {
                if (state.words.length >= 5) {
                  currentTranslationList.addAll(state.words.getRange(0, 5));
                } else {
                  currentTranslationList.addAll(state.words);
                }
                currentTranslationList.shuffle();
              }
              return _buildWordCardDeck();
            } else {
              return const SizedBox();
            }
          },
        ));
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildWordCardDeck() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(S.of(context).mistakesCount(mistakes.length)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    S.of(context).correctAnswersCount(correctAnswers.length)),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildWordCard(currentWordsList),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTranslationCard(currentTranslationList),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWordCard(List<MatchingTrainingEntity> words) {
    return SizedBox(
      height: 500,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: words.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 80,
                width: 150,
                child: OutlinedButton(
                  onPressed: () async {
                    List<MatchingTrainingEntity> correctAnswerstoSend = [];
                    List<
                        (
                          MatchingTrainingEntity word,
                          List<String> wrongChoices,
                          bool isSourceChosen
                        )> mistakesToSend = [];
                    if (correctAnswers.contains(words[index])) {
                      return;
                    } else if (isTranslationChosenWrong) {
                      return;
                    }
                    if (isTranslationChosen) {
                      isWordChosen = true;
                      currentAnswer.add(words[index]);
                      if (isWordChosen &&
                          currentAnswer[0].id == currentAnswer[1].id) {
                        await pool.play(correctSoundId);
                        setState(() {
                          currentAnswer.clear();
                          isWordChosen = false;
                          isTranslationChosen = false;
                          isWordChosenWrong = false;
                          colors.replaceRange(0, 5, [
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                          ]);
                          correctAnswers.add(words[index]);
                          if (wordsList.length >= 5 &&
                              correctAnswers.length % 5 == 0) {
                            List<MatchingTrainingEntity> toAdd =
                                wordsList.getRange(0, 5).toList();
                            currentWordsList.clear();
                            currentWordsList.addAll(toAdd);
                            currentTranslationList.clear();
                            currentTranslationList.addAll(toAdd);
                            currentTranslationList.shuffle();
                            wordsList.removeRange(0, 5);
                            colors.replaceRange(0, 5, [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ]);
                            colors.replaceRange(5, 10, [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ]);
                          } else if (wordsList.isNotEmpty &&
                              wordsList.length < 5 &&
                              correctAnswers.length % 5 == 0) {
                            List<MatchingTrainingEntity> toAdd = wordsList
                                .getRange(0, wordsList.length)
                                .toList();
                            currentWordsList.clear();
                            currentWordsList.addAll(toAdd);
                            currentTranslationList.clear();
                            currentTranslationList.addAll(toAdd);
                            currentTranslationList.shuffle();
                            wordsList.clear();
                            colors.replaceRange(0, 5, [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ]);
                            colors.replaceRange(5, 10, [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ]);
                          } else if (wordsList.isEmpty &&
                                  correctAnswers.length % 5 ==
                                      currentWordsList.length ||
                              wordsList.isEmpty &&
                                  correctAnswers.length % 5 == 0) {
                            correctAnswerstoSend.addAll(correctAnswers);
                            correctAnswerstoSend.removeWhere((element) =>
                                mistakes.any((e) => e.$1 == element));
                            mistakesToSend.addAll(mistakes);
                            final uniqueSources = <String>{};
                            mistakesToSend.removeWhere(
                                (item) => !uniqueSources.add(item.$1.source));
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (ctx) => TrainingResultListPage(
                                  answers:
                                      prepareAnswers(correctAnswers, mistakes),
                                  onPressed: () {
                                    if (widget.setId.isNotEmpty) {
                                      BlocProvider.of<TrainingsBloc>(ctx).add(
                                          FetchSetWordsForMatchingTRainings(
                                              widget.setId));
                                      Navigator.of(ctx).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              MatchingInProcessPage(
                                                  setId: widget.setId),
                                        ),
                                      );
                                    } else {
                                      BlocProvider.of<TrainingsBloc>(ctx).add(
                                          const FetchWordsForMatchingTRainings());
                                      Navigator.of(ctx).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              const MatchingInProcessPage(
                                                  setId: ''),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                            BlocProvider.of<TrainingsBloc>(context).add(
                                UpdateWordsForMatchingTRainings(
                                    correctAnswerstoSend));
                          }
                          //colors[index] = Colors.green;
                        });
                      } else {
                        await pool.play(wrongSoundId);
                        isWordChosen = false;
                        isWordChosenWrong = true;
                        currentAnswer.remove(words[index]);
                        final alreadyInMistakes =
                            mistakes.any((e) => e.$1 == currentAnswer[0]);

                        if (!alreadyInMistakes) {
                          mistakes.add((
                            currentAnswer[0],
                            [words[index].source],
                            false
                          )); // true → выбран source (слово)
                        } else {
                          final indexInMistakes = mistakes
                              .indexWhere((e) => e.$1 == currentAnswer[0]);
                          mistakes[indexInMistakes].$2.add(words[index].source);
                        }
                        colors.replaceRange(0, 5, [
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Colors.white,
                        ]);
                        setState(() {
                          colors[index] = const Color(0xFFB70E0E);
                        });
                      }
                    } else {
                      setState(() {
                        isWordChosen = true;
                        currentAnswer.clear();
                        currentAnswer.add(words[index]);
                        colors.replaceRange(0, 5, [
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Colors.white,
                        ]);
                        colors[index] = const Color(0xFFd9c3ac);
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: correctAnswers.contains(words[index])
                        ? const Color(0xFF85977f)
                        : colors[index],
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Color(0xFFD9C3AC),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        words[index].source,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildTranslationCard(List<MatchingTrainingEntity> words) {
    return SizedBox(
      height: 500,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: words.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 80,
                width: 150,
                child: OutlinedButton(
                  onPressed: () async {
                    List<MatchingTrainingEntity> correctAnswerstoSend = [];
                    List<
                        (
                          MatchingTrainingEntity word,
                          List<String> wrongChoices,
                          bool isSourceChosen
                        )> mistakesToSend = [];
                    if (correctAnswers.contains(words[index])) {
                      return;
                    } else if (isWordChosenWrong) {
                      return;
                    }
                    if (isWordChosen) {
                      isTranslationChosen = true;
                      currentAnswer.insert(0, words[index]);
                      if (isTranslationChosen &&
                          currentAnswer[0].id == currentAnswer[1].id) {
                        await pool.play(correctSoundId);
                        setState(() {
                          currentAnswer.clear();
                          isWordChosen = false;
                          isTranslationChosen = false;
                          isTranslationChosenWrong = false;
                          colors.replaceRange(5, 10, [
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                          ]);
                          correctAnswers.add(words[index]);
                          if (wordsList.length >= 5 &&
                              correctAnswers.length % 5 == 0) {
                            List<MatchingTrainingEntity> toAdd =
                                wordsList.getRange(0, 5).toList();
                            currentWordsList.clear();
                            currentWordsList.addAll(toAdd);
                            currentTranslationList.clear();
                            currentTranslationList.addAll(toAdd);
                            currentTranslationList.shuffle();
                            wordsList.removeRange(0, 5);
                            colors.replaceRange(0, 5, [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ]);
                            colors.replaceRange(5, 10, [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ]);
                          } else if (wordsList.isNotEmpty &&
                              wordsList.length < 5 &&
                              correctAnswers.length % 5 == 0) {
                            List<MatchingTrainingEntity> toAdd = wordsList
                                .getRange(0, wordsList.length)
                                .toList();
                            currentWordsList.clear();
                            currentWordsList.addAll(toAdd);
                            currentTranslationList.clear();
                            currentTranslationList.addAll(toAdd);
                            currentTranslationList.shuffle();
                            wordsList.clear();
                            colors.replaceRange(0, 5, [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ]);
                            colors.replaceRange(5, 10, [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ]);
                          } else if (wordsList.isEmpty &&
                                  correctAnswers.length % 5 ==
                                      currentWordsList.length ||
                              wordsList.isEmpty &&
                                  correctAnswers.length % 5 == 0) {
                            correctAnswerstoSend.addAll(correctAnswers);
                            correctAnswerstoSend.removeWhere((element) =>
                                mistakes.any((e) => e.$1 == element));
                            mistakesToSend.addAll(mistakes);
                            final uniqueSources = <String>{};
                            mistakesToSend.removeWhere(
                                (item) => !uniqueSources.add(item.$1.source));
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (ctx) => TrainingResultListPage(
                                  answers:
                                      prepareAnswers(correctAnswers, mistakes),
                                  onPressed: () {
                                    if (widget.setId.isNotEmpty) {
                                      BlocProvider.of<TrainingsBloc>(ctx).add(
                                          FetchSetWordsForMatchingTRainings(
                                              widget.setId));
                                      Navigator.of(ctx).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              MatchingInProcessPage(
                                                  setId: widget.setId),
                                        ),
                                      );
                                    } else {
                                      BlocProvider.of<TrainingsBloc>(ctx).add(
                                          const FetchWordsForMatchingTRainings());
                                      Navigator.of(ctx).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              const MatchingInProcessPage(
                                                  setId: ''),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                            BlocProvider.of<TrainingsBloc>(context).add(
                                UpdateWordsForMatchingTRainings(
                                    correctAnswerstoSend));
                          }
                          //colors[index + 5] = Colors.green;
                        });
                      } else {
                        await pool.play(wrongSoundId);
                        isTranslationChosen = false;
                        isTranslationChosenWrong = true;
                        currentAnswer.remove(words[index]);
                        final alreadyInMistakes =
                            mistakes.any((e) => e.$1 == currentAnswer[0]);

                        if (!alreadyInMistakes) {
                          mistakes.add((
                            currentAnswer[0],
                            [words[index].translation],
                            true
                          )); // false → выбран translation
                        } else {
                          final indexInMistakes = mistakes
                              .indexWhere((e) => e.$1 == currentAnswer[0]);
                          mistakes[indexInMistakes]
                              .$2
                              .add(words[index].translation);
                        }

                        colors.replaceRange(5, 10, [
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Colors.white,
                        ]);
                        setState(() {
                          colors[index + 5] = const Color(0xFFB70E0E);
                        });
                      }
                    } else {
                      setState(() {
                        isTranslationChosen = true;
                        isTranslationChosenWrong = false;
                        currentAnswer.clear();
                        currentAnswer.add(words[index]);
                        colors.replaceRange(5, 10, [
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Colors.white,
                        ]);
                        colors[index + 5] = const Color(0xFFd9c3ac);
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: correctAnswers.contains(words[index])
                        ? const Color(0xFF85977f)
                        : colors[index + 5],
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Color(0xFFD9C3AC),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        words[index].translation,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
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

List<(String source, String translation, String? wrongAnswer)> prepareAnswers(
  List<MatchingTrainingEntity> correctAnswers,
  List<
          (
            MatchingTrainingEntity word,
            List<String> wrongChoices,
            bool isSourceChosen
          )>
      mistakes,
) {
  return correctAnswers.map((correct) {
    final matchingMistakes = mistakes.where((e) => e.$1 == correct);

    if (matchingMistakes.isNotEmpty) {
      final mistake = matchingMistakes.first;
      final word = mistake.$1;
      final wrongChoices = mistake.$2;
      final isSource = mistake.$3;

      return (
        isSource ? word.source : word.translation,
        isSource ? word.translation : word.source,
        wrongChoices.isNotEmpty ? wrongChoices.join(', ') : null,
      );
    } else {
      return (
        correct.source,
        correct.translation,
        null,
      );
    }
  }).toList();
}
