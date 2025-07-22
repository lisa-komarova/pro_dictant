import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/matching_in_process_page.dart';

import '../../domain/entities/matching_training_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';

class MatchingResultPage extends StatelessWidget {
  final List<MatchingTrainingEntity> correctAnswers;
  final List<MatchingTrainingEntity> mistakes;
  final String setId;

  const MatchingResultPage({
    required this.correctAnswers,
    required this.mistakes,
    super.key,
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0x6BD9C3AC),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Text(
                                S.of(context).rightAnswers,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: correctAnswers.length,
                                  itemBuilder: (ctx, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              correctAnswers[index].source +
                                                  ' -\n' +
                                                  correctAnswers[index]
                                                      .translation,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color(0xFF85977f)),
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/icons/divider.png',
                                          width: 15,
                                          height: 15,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0x6BD9C3AC),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Text(
                                S.of(context).mistakes,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: mistakes.length,
                                  itemBuilder: (ctx, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              mistakes[index].source +
                                                  ' -\n' +
                                                  mistakes[index].translation,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color(0xFFB70E0E)),
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/icons/divider.png',
                                          width: 15,
                                          height: 15,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (setId.isNotEmpty) {
                    BlocProvider.of<TrainingsBloc>(context)
                        .add(FetchSetWordsForMatchingTRainings(setId));
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => MatchingInProcessPage(
                              setId: setId,
                            )));
                  } else {
                    BlocProvider.of<TrainingsBloc>(context)
                        .add(const FetchWordsForMatchingTRainings());
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => const MatchingInProcessPage(
                              setId: "",
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
          ),
        ],
      )),
    );
  }
}
