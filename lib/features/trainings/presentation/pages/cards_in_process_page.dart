import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/trainings/domain/entities/cards_training_entity.dart';

import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';
import 'cards_result_page.dart';

class CardsInProcessPage extends StatefulWidget {
  const CardsInProcessPage({super.key});

  @override
  State<CardsInProcessPage> createState() => _CardsInProcessPageState();
}

class _CardsInProcessPageState extends State<CardsInProcessPage>
    with TickerProviderStateMixin {
  int currentWordIndex = 0;
  Duration _elapsed = Duration.zero;
  Duration _dif = Duration.zero;
  late final Ticker _ticker;
  List<String> suggestedAnswer = [];
  List<CardsTrainingEntity> correctAnswers = [];
  List<CardsTrainingEntity> mistakes = [];

  @override
  void initState() {
    _ticker = createTicker((elapsed) {
      // 4. update state
      setState(() {
        if (currentWordIndex == 0) {
          _dif = elapsed;
        }
        _elapsed = elapsed - _dif;
        if (_elapsed.inSeconds > 60) {
          finishWorkout();
        }
      });
    });
    // 5. start ticker
    _ticker.start();
    super.initState();
  }

  @override
  void dispose() {
    //timer.cancel();
    _ticker.dispose();
    super.dispose();
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
                "Пока недостаточно слов для тренировки ˙◠˙",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            );
          } else if (state is TrainingLoading) {
            return _loadingIndicator();
          } else if (state is CardsTrainingLoaded) {
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

  Widget _buildWordCard(List<CardsTrainingEntity> words) {
    if (suggestedAnswer.isEmpty) {
      suggestedAnswer.add(words[currentWordIndex].translation);
      suggestedAnswer.add(words[currentWordIndex].wrongTranslation);
      suggestedAnswer.shuffle();
    }
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
          child: Text(
            '${_elapsed.inSeconds}/60',
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
                    onTap: () {
                      if (currentWordIndex > 98) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => CardsResultPage(
                                  correctAnswers: correctAnswers,
                                  mistakes: mistakes,
                                )));
                        // BlocProvider.of<TrainingsBloc>(context)
                        //     .add(UpdateWordsForCardsTRainings(toUpdate));
                        return;
                      }
                      if (suggestedAnswer.first ==
                          words[currentWordIndex].translation) {
                        correctAnswers.add(words[currentWordIndex]);
                      } else {
                        mistakes.add(words[currentWordIndex]);
                      }
                      setState(() {
                        currentWordIndex++;
                        suggestedAnswer = [];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFd9c3ac),
                      ),
                      height: 100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AutoSizeText(
                            suggestedAnswer.first,
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
                    onTap: () {
                      if (currentWordIndex > 500) {
                        finishWorkout();
                      }
                      if (suggestedAnswer.last ==
                          words[currentWordIndex].translation) {
                        correctAnswers.add(words[currentWordIndex]);
                      } else {
                        mistakes.add(words[currentWordIndex]);
                      }
                      setState(() {
                        currentWordIndex++;
                        suggestedAnswer = [];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFd9c3ac),
                      ),
                      height: 100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AutoSizeText(
                            suggestedAnswer.last,
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

  void finishWorkout() {
    final wordsList = correctAnswers.map((e) => e.id).toSet();
    final mistakesList = mistakes.map((e) => e.id).toSet();
    correctAnswers.retainWhere((x) => wordsList.remove(x.id));
    mistakes.retainWhere((element) => mistakesList.remove(element.id));
    correctAnswers.removeWhere((element) => mistakesList.remove(element.id));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => CardsResultPage(
              correctAnswers: correctAnswers,
              mistakes: mistakes,
            )));
    BlocProvider.of<TrainingsBloc>(context)
        .add(UpdateWordsForCardsTRainings(correctAnswers));
  }
}
