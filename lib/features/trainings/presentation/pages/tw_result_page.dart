import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/domain/entities/tw_training_entity.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/tw_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/wt_result_block_widget.dart';

class TWResultPage extends StatelessWidget {
  final Map<String, String> answers;
  final List<TWTrainingEntity> words;
  final String setId;

  const TWResultPage({
    super.key,
    required this.answers,
    required this.words,
    required this.setId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              return Navigator.of(context).pop();
            },
            icon: Image.asset('assets/icons/cancel.png')),
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            S.of(context).results,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...buildAnswers(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                if (setId.isNotEmpty) {
                  BlocProvider.of<TrainingsBloc>(context)
                      .add(FetchSetWordsForTwTRainings(setId));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => TWInProcessPage(
                            setId: setId,
                          )));
                } else {
                  BlocProvider.of<TrainingsBloc>(context)
                      .add(const FetchWordsForTwTRainings());
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => const TWInProcessPage(
                            setId: '',
                          )));
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFFD9C3AC),
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  S.of(context).continueTraining,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  List<Widget> buildAnswers() {
    List<Widget> answersWidgets = [];

    answers.forEach((key, value) {
      String correctAnswer =
          words.where((element) => element.id == key).toList().first.source;
      String translation = words
          .where((element) => element.id == key)
          .toList()
          .first
          .translation;
      answersWidgets.add(
        WTResultBlockWidget(
          source: translation,
          correctAnswer: correctAnswer,
          answer: value,
        ),
      );
    });
    return answersWidgets;
  }
}
