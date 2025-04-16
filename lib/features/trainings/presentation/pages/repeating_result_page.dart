import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeating_in_process_page.dart';

import '../../domain/entities/repeating_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';

class RepeatingResultPage extends StatelessWidget {
  final String setId;
  final List<RepeatingTrainingEntity> mistakes;
  final List<RepeatingTrainingEntity> learnt;
  final List<RepeatingTrainingEntity> learning;

  const RepeatingResultPage({
    required this.mistakes,
    super.key,
    required this.setId,
    required this.learnt,
    required this.learning,
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      mistakes.isNotEmpty
                          ? SizedBox(
                              child: Text(
                                S.of(context).sentToLearning,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            )
                          : const SizedBox.shrink(),
                      mistakes.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: mistakes.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SingleChildScrollView(
                                      child: Text(
                                        mistakes[index].source,
                                        style: const TextStyle(
                                            color: Color(0xFFB70E0E)),
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/icons/divider.png',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ],
                                );
                              })
                          : const SizedBox.shrink(),
                      learnt.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                child: Text(
                                  S.of(context).sentToLearnt,
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      learnt.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: learnt.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: Text(
                                        learnt[index].source,
                                        style: const TextStyle(
                                            color: Color(0xFF85977f)),
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/icons/divider.png',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ],
                                );
                              })
                          : const SizedBox.shrink(),
                      learning.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                child: Text(
                                  S.of(context).onLearning,
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      learning.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: learning.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: Text(
                                        learning[index].source,
                                        style: const TextStyle(
                                            color: Color(0xFFC0A183)),
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/icons/divider.png',
                                      width: 15,
                                      height: 15,
                                    ),
                                  ],
                                );
                              })
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
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
                        .add(FetchSetWordsForRepeatingTRainings(setId));
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => RepeatingInProcessPage(
                              setId: setId,
                            )));
                  } else {
                    BlocProvider.of<TrainingsBloc>(context)
                        .add(const FetchWordsForRepeatingTRainings());
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => const RepeatingInProcessPage(
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
          ),
        ],
      )),
    );
  }
}
