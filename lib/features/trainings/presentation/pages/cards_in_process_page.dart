import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/domain/entities/cards_training_entity.dart';

import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';
import 'cards_result_page.dart';

class CardsInProcessPage extends StatefulWidget {
  final String setId;

  const CardsInProcessPage({
    super.key,
    required this.setId,
  });

  @override
  State<CardsInProcessPage> createState() => _CardsInProcessPageState();
}

class _CardsInProcessPageState extends State<CardsInProcessPage>
    with TickerProviderStateMixin {
  int currentWordIndex = 0;
  List<String> suggestedAnswer = [];
  List<CardsTrainingEntity> correctAnswers = [];
  List<CardsTrainingEntity> mistakes = [];
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                words[currentWordIndex].source,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: FilledButton(
                      onPressed: () {
                        if (currentWordIndex + 1 >= words.length) {
                          finishWorkout();
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFd9c3ac),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: FilledButton(
                      onPressed: () {
                        if (currentWordIndex + 1 >= words.length) {
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFd9c3ac),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
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
              setId: widget.setId,
            )));
    BlocProvider.of<TrainingsBloc>(context)
        .add(UpdateWordsForCardsTRainings(correctAnswers));
  }
}
