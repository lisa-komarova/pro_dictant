import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_state.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/wt_result_page.dart';

class WTInProcessPage extends StatefulWidget {
  const WTInProcessPage({super.key});

  @override
  State<WTInProcessPage> createState() => _WTInProcessPageState();
}

class _WTInProcessPageState extends State<WTInProcessPage> {
  int currentWordIndex = 0;
  Map<String, String> answers = {};

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
            } else if (state is WTTrainingLoaded) {
              return _buildWordCard(state.words);
            } else {
              return const SizedBox();
            }
          },
        ));
  }

  Widget _buildWordCard(List<WTTrainingEntity> words) {
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
          child: Text(
            words[currentWordIndex].source,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Flexible(
          flex: 4,
          child: GridView.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 2,
              children: <Widget>[
                ...buildSuggestedAnswers(words),
              ]),
        )
      ],
    );
  }

  void updateCurrentWord(List<WTTrainingEntity> words) {
    if (currentWordIndex + 1 >= words.length) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => WTResultPage(
                answers: answers,
                words: words,
              )));
      List<String> toUpdate = [];
      answers.forEach((key, value) {
        String correctAnswer = words
            .where((element) => element.id == key)
            .toList()
            .first
            .translation;
        if (correctAnswer == value) {
          toUpdate.add(key);
        }
      });
      BlocProvider.of<TrainingsBloc>(context)
          .add(UpdateWordsForWtTRainings(toUpdate));
      return;
    }
    setState(() {
      currentWordIndex++;
    });
  }

  List<Widget> buildSuggestedAnswers(List<WTTrainingEntity> words) {
    List<Widget> answersContainers = [];
    var rng = Random();
    Set<int> randomSequence = {};
    do {
      randomSequence.add(rng.nextInt(4));
    } while (randomSequence.length < 4);

    for (var element in randomSequence) {
      element == 3
          ? answersContainers.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  answers[words[currentWordIndex].id] =
                      words[currentWordIndex].translation;
                  updateCurrentWord(words);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFd9c3ac),
                  ),
                  height: 25,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: AutoSizeText(
                        words[currentWordIndex].translation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ))
          : answersContainers.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  answers[words[currentWordIndex].id] = words[currentWordIndex]
                      .suggestedTranslationList[element]
                      .translation;
                  updateCurrentWord(words);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFd9c3ac),
                  ),
                  height: 25,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: AutoSizeText(
                        words[currentWordIndex]
                            .suggestedTranslationList[element]
                            .translation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
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
}
