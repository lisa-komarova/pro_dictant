import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/wt_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/continue_training_button.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/training_list_result_block_widget.dart';

class WTResultPage extends StatelessWidget {
  final Map<String, String> answers;
  final List<WTTrainingEntity> words;
  final String setId;
  const WTResultPage({
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...buildAnswers(),
                  ],
                ),
              ),
            ),
          ),
          ContinueTrainingButton(onPressed: () {
            if (setId.isNotEmpty) {
              BlocProvider.of<TrainingsBloc>(context)
                  .add(FetchSetWordsForWtTRainings(setId));
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => WTInProcessPage(
                        setId: setId,
                      )));
            } else {
              BlocProvider.of<TrainingsBloc>(context)
                  .add(const FetchWordsForWtTRainings());
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => const WTInProcessPage(
                        setId: '',
                      )));
            }
          })
        ],
      )),
    );
  }

  List<Widget> buildAnswers() {
    List<Widget> answersWidgets = [];

    answers.forEach((key, value) {
      String correctAnswer = words
          .where((element) => element.id == key)
          .toList()
          .first
          .translation;
      String source =
          words.where((element) => element.id == key).toList().first.source;
      answersWidgets.add(
        TrainingListResultBlockWidget(
          source: source,
          correctAnswer: correctAnswer,
          answer: value,
        ),
      );
    });
    return answersWidgets;
  }
}
