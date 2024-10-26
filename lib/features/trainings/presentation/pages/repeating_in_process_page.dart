import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeating_result_page.dart';

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
  Color colorPositive = Color(0xFFd9c3ac);
  Color colorNegative = Color(0xFFd9c3ac);
  Color colorNeutral = Color(0xFFd9c3ac);
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
                "Пока недостаточно слов для тренировки ˙◠˙",
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
                  'Завершить тренировку',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Color(0xFF85977f)),
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
                        colorPositive = Color(0xFF85977f);
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        colorPositive = Color(0xFFd9c3ac);
                      });
                    },
                    onVerticalDragStart: (details) {
                      setState(() {
                        colorPositive = Color(0xFFd9c3ac);
                      });
                    },
                    onHorizontalDragStart: (details) {
                      setState(() {
                        colorPositive = Color(0xFFd9c3ac);
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
                            "знаю \nне забуду",
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
                        colorNeutral = Color(0xFFffffff);
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        colorNeutral = Color(0xFFd9c3ac);
                      });
                    },
                    onVerticalDragStart: (details) {
                      setState(() {
                        colorNeutral = Color(0xFFd9c3ac);
                      });
                    },
                    onHorizontalDragStart: (details) {
                      setState(() {
                        colorNeutral = Color(0xFFd9c3ac);
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
                            "знаю\nно забываю",
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
                        colorNegative = Color(0xFFB70E0E);
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        colorNegative = Color(0xFFd9c3ac);
                      });
                    },
                    onVerticalDragStart: (details) {
                      setState(() {
                        colorNegative = Color(0xFFd9c3ac);
                      });
                    },
                    onHorizontalDragStart: (details) {
                      setState(() {
                        colorNegative = Color(0xFFd9c3ac);
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
                            'не помню',
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

// void finishWorkout() {
//   final wordsList = correctAnswers.map((e) => e.id).toSet();
//   final mistakesList = mistakes.map((e) => e.id).toSet();
//   correctAnswers.retainWhere((x) => wordsList.remove(x.id));
//   mistakes.retainWhere((element) => mistakesList.remove(element.id));
//   correctAnswers.removeWhere((element) => mistakesList.remove(element.id));
//   Navigator.of(context).pushReplacement(MaterialPageRoute(
//       builder: (ctx) => CardsResultPage(
//             correctAnswers: correctAnswers,
//             mistakes: mistakes,
//           )));
//   BlocProvider.of<TrainingsBloc>(context)
//       .add(UpdateWordsForRepeatedTRainings(correctAnswers));
// }
}
