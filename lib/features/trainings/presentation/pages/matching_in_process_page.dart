import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/trainings/domain/entities/matching_training_entity.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_state.dart';

import 'matching_result_page.dart';

class MatchingInProcessPage extends StatefulWidget {
  const MatchingInProcessPage({super.key});

  @override
  State<MatchingInProcessPage> createState() => _MatchingInProcessPageState();
}

class _MatchingInProcessPageState extends State<MatchingInProcessPage> {
  bool isWordChosen = false;
  bool isTranslationChosen = false;
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
  List<MatchingTrainingEntity> mistakes = [];

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
                  "Пока недостаточно слов для тренировки ˙◠˙",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              );
            } else if (state is TrainingLoading) {
              return _loadingIndicator();
            } else if (state is MatchingTrainingLoaded) {
              if (wordsList.isEmpty && correctAnswers.isEmpty) {
                int toRemove = state.words.length % 5;
                state.words.length -= toRemove;
                wordsList.addAll(state.words);
                wordsList.removeRange(0, 5);
              }
              if (currentWordsList.isEmpty) {
                currentWordsList.addAll(state.words.getRange(0, 5));
              }
              if (currentTranslationList.isEmpty) {
                currentTranslationList.addAll(state.words.getRange(0, 5));
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
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('ошибок: ${mistakes.length}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('ответов: ${correctAnswers.length}'),
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
          itemCount: 5,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (correctAnswers.contains(words[index])) {
                  return;
                }
                if (isTranslationChosen) {
                  isWordChosen = true;
                  currentAnswer.add(words[index]);
                  if (isWordChosen &&
                      currentAnswer[0].id == currentAnswer[1].id) {
                    setState(() {
                      currentAnswer.clear();
                      isWordChosen = false;
                      isTranslationChosen = false;
                      colors.replaceRange(0, 5, [
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ]);
                      correctAnswers.add(words[index]);
                      if (wordsList.isNotEmpty &&
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
                      } else if (wordsList.isEmpty &&
                          correctAnswers.length % 5 == 0) {
                        correctAnswers.removeWhere(
                            (element) => mistakes.contains(element));

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => MatchingResultPage(
                                correctAnswers: correctAnswers,
                                mistakes: mistakes)));
                        BlocProvider.of<TrainingsBloc>(context).add(
                            UpdateWordsForMatchingTRainings(correctAnswers));
                      }
                      //colors[index] = Colors.green;
                    });
                  } else {
                    isWordChosen = false;
                    currentAnswer.remove(words[index]);
                    mistakes.add(words[index]);
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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 70,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: correctAnswers.contains(words[index])
                        ? const Color(0xFF85977f)
                        : colors[index],
                    border: Border.all(
                      color: const Color(0xFFD9C3AC),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        words[index].source,
                        style: Theme.of(context).textTheme.titleMedium,
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
          itemCount: 5,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (correctAnswers.contains(words[index])) {
                  return;
                }
                if (isWordChosen) {
                  isTranslationChosen = true;
                  currentAnswer.insert(0, words[index]);
                  if (isTranslationChosen &&
                      currentAnswer[0].id == currentAnswer[1].id) {
                    setState(() {
                      currentAnswer.clear();
                      isWordChosen = false;
                      isTranslationChosen = false;
                      colors.replaceRange(5, 10, [
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ]);
                      correctAnswers.add(words[index]);
                      if (wordsList.isNotEmpty &&
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
                      } else if (wordsList.isEmpty &&
                          correctAnswers.length % 5 == 0) {
                        correctAnswers.removeWhere(
                            (element) => mistakes.contains(element));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => MatchingResultPage(
                                correctAnswers: correctAnswers,
                                mistakes: mistakes)));
                        BlocProvider.of<TrainingsBloc>(context).add(
                            UpdateWordsForMatchingTRainings(correctAnswers));
                      }
                      //colors[index + 5] = Colors.green;
                    });
                  } else {
                    isTranslationChosen = false;
                    currentAnswer.remove(words[index]);
                    mistakes.add(words[index]);
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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 70,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: correctAnswers.contains(words[index])
                        ? const Color(0xFF85977f)
                        : colors[index + 5],
                    border: Border.all(
                      color: const Color(0xFFD9C3AC),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        words[index].translation,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
