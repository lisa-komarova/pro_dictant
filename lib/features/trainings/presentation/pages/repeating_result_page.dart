import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeating_in_process_page.dart';

import '../../domain/entities/repeating_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';

class RepeatingResultPage extends StatelessWidget {
  final List<RepeatingTrainingEntity> mistakes;

  const RepeatingResultPage({required this.mistakes, super.key});

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
            'Результаты',
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
                child: Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Text(
                                'отправлено на изучение',
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
                                          '${mistakes[index].source}',
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
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<TrainingsBloc>(context)
                      .add(const FetchWordsForRepeatingTRainings());
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => const RepeatingInProcessPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9C3AC),
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    'продолжить тренировку',
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
