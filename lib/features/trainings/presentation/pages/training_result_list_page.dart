import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/domain/entities/tw_training_entity.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/tw_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/continue_training_button.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/training_list_result_block_widget.dart';

class TrainingResultListPage extends StatelessWidget {
  final List<(String source, String translation, String? wrongAnswer)> answers;
  final VoidCallback onPressed;

  const TrainingResultListPage({
    super.key,
    required this.answers,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
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
            ContinueTrainingButton(onPressed: onPressed),
          ],
        )),
      ),
    );
  }

  List<Widget> buildAnswers() {
    List<Widget> answersWidgets = [];

    answers.forEach((element) {
      answersWidgets.add(
        TrainingListResultBlockWidget(
          source: element.$1,
          correctAnswer: element.$2,
          answer: element.$3,
        ),
      );
    });
    return answersWidgets;
  }
}
