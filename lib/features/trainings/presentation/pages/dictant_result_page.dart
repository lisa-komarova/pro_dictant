import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/domain/entities/dictant_training_entity.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/dictant_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/continue_training_button.dart';

class DictantResultPage extends StatelessWidget {
  final List<DictantTrainingEntity> correctAnswers;
  final List<DictantTrainingEntity> mistakes;
  final String setId;

  const DictantResultPage({
    super.key,
    required this.correctAnswers,
    required this.mistakes,
    required this.setId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Image.asset('assets/icons/cancel.png'),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            S.of(context).results,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (correctAnswers.isNotEmpty)
                    ..._buildAnswerList(
                      correctAnswers,
                      const Color(0xFF85977f),
                      false,
                    ),
                  if (mistakes.isNotEmpty)
                    ..._buildAnswerList(
                      mistakes,
                      const Color(0xFFB70E0E),
                      true,
                    ),
                ],
              ),
            ),
          ),
          ContinueTrainingButton(
            onPressed: () {
              if (setId.isNotEmpty) {
                BlocProvider.of<TrainingsBloc>(context)
                    .add(FetchSetWordsForDictantTRainings(setId));
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => DictantInProcessPage(setId: setId),
                  ),
                );
              } else {
                BlocProvider.of<TrainingsBloc>(context)
                    .add(const FetchWordsForDictantTRainings());
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => const DictantInProcessPage(setId: ''),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnswerList(
    List<DictantTrainingEntity> list,
    Color color,
    bool isMistakes,
  ) {
    return list.map((e) {
      return SizedBox(
        height: 90,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x6BD9C3AC),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 2),
                                child: Text(
                                  e.source,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  e.translation,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: isMistakes
                          ? Image.asset(
                              'assets/icons/cancel.png',
                              width: 15,
                              height: 15,
                              color: const Color(0xFFB70E0E),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/icons/divider.png',
              width: 15,
              height: 15,
            ),
          ],
        ),
      );
    }).toList();
  }
}
