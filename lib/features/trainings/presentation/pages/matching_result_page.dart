import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/matching_in_process_page.dart';

import '../../../../generated/l10n.dart';
import '../../domain/entities/matching_training_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';

class MatchingResultPage extends StatelessWidget {
  final List<MatchingTrainingEntity> correctAnswers;
  final List<MatchingTrainingEntity> mistakes;

  const MatchingResultPage(
      {required this.correctAnswers, required this.mistakes, super.key});

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
      body: Center(
          child: Column(
        children: [
          Text(
            S.of(context).results,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
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
                                    children: [
                                      Text(
                                        correctAnswers[index].source,
                                        style: const TextStyle(
                                            color: Color(0xFF85977f)),
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
                    Expanded(
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
                                    children: [
                                      Text(
                                        mistakes[index].source,
                                        style: const TextStyle(
                                            color: Color(0xFFB70E0E)),
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
                    )
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<TrainingsBloc>(context)
                      .add(const FetchWordsForMatchingTRainings());
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => const MatchingInProcessPage()));
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
