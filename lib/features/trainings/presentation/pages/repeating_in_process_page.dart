import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeating_result_page.dart';

import '../../../../generated/l10n.dart';
import '../../domain/entities/repeating_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';

class RepeatingInProcessPage extends StatefulWidget {
  const RepeatingInProcessPage({super.key});

  @override
  State<RepeatingInProcessPage> createState() => _CardsInProcessPageState();
}

class _CardsInProcessPageState extends State<RepeatingInProcessPage> {
  int currentWordIndex = 0;
  Color colorPositive = const Color(0xFFd9c3ac);
  Color colorNegative = const Color(0xFFd9c3ac);
  Color colorNeutral = const Color(0xFFd9c3ac);
  List<RepeatingTrainingEntity> mistakes = [];
  List<RepeatingTrainingEntity> correctAnswers = [];

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
          } else if (state is RepeatingTrainingLoaded) {
            return _buildWordCard(state.words);
          } else {
            return const SizedBox();
          }
        },
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

  Widget _buildWordCard(List<RepeatingTrainingEntity> words) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Column(
            children: [
              Text(
                '${currentWordIndex + 1}/${words.length}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => RepeatingResultPage(
                            mistakes: mistakes,
                          )));
                  BlocProvider.of<TrainingsBloc>(context).add(
                      UpdateWordsForRepeatingTRainings(
                          mistakes, correctAnswers));
                },
                child: Text(
                  S.of(context).endTrainings,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: const Color(0xFF85977f)),
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
        Flexible(
          flex: 2,
          child: Center(
            child: Text(
              words[currentWordIndex].source,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        colorPositive = const Color(0xFF85977f);
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        colorPositive = const Color(0xFFd9c3ac);
                      });
                    },
                    onVerticalDragStart: (details) {
                      setState(() {
                        colorPositive = const Color(0xFFd9c3ac);
                      });
                    },
                    onHorizontalDragStart: (details) {
                      setState(() {
                        colorPositive = const Color(0xFFd9c3ac);
                      });
                    },
                    onTap: () {
                      if (currentWordIndex + 1 >= words.length) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => RepeatingResultPage(
                                  mistakes: mistakes,
                                )));
                        BlocProvider.of<TrainingsBloc>(context).add(
                            UpdateWordsForRepeatingTRainings(
                                mistakes, correctAnswers));
                        return;
                      }
                      correctAnswers.add(words[currentWordIndex]);
                      setState(() {
                        currentWordIndex++;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colorPositive,
                      ),
                      height: 100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AutoSizeText(
                            S.of(context).iKnowWontForget,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        colorNeutral = const Color(0xFFffffff);
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        colorNeutral = const Color(0xFFd9c3ac);
                      });
                    },
                    onVerticalDragStart: (details) {
                      setState(() {
                        colorNeutral = const Color(0xFFd9c3ac);
                      });
                    },
                    onHorizontalDragStart: (details) {
                      setState(() {
                        colorNeutral = const Color(0xFFd9c3ac);
                      });
                    },
                    onTap: () {
                      if (currentWordIndex + 1 >= words.length) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => RepeatingResultPage(
                                  mistakes: mistakes,
                                )));
                        BlocProvider.of<TrainingsBloc>(context).add(
                            UpdateWordsForRepeatingTRainings(
                                mistakes, correctAnswers));
                        return;
                      }
                      setState(() {
                        currentWordIndex++;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colorNeutral,
                      ),
                      height: 100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AutoSizeText(
                            S.of(context).iKnowMightForget,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        colorNegative = const Color(0xFFB70E0E);
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        colorNegative = const Color(0xFFd9c3ac);
                      });
                    },
                    onVerticalDragStart: (details) {
                      setState(() {
                        colorNegative = const Color(0xFFd9c3ac);
                      });
                    },
                    onHorizontalDragStart: (details) {
                      setState(() {
                        colorNegative = const Color(0xFFd9c3ac);
                      });
                    },
                    onTap: () {
                      if (currentWordIndex + 1 >= words.length) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => RepeatingResultPage(
                                  mistakes: mistakes,
                                )));
                        BlocProvider.of<TrainingsBloc>(context).add(
                            UpdateWordsForRepeatingTRainings(
                                mistakes, correctAnswers));
                        return;
                      }
                      mistakes.add(words[currentWordIndex]);
                      setState(() {
                        currentWordIndex++;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colorNegative,
                      ),
                      height: 100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AutoSizeText(
                            S.of(context).iDontRemember,
                            textAlign: TextAlign.center,
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
}
