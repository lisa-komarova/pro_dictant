import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/cards_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/continue_training_button.dart';

import '../../domain/entities/cards_training_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';

class CardsResultPage extends StatelessWidget {
  final List<CardsTrainingEntity> correctAnswers;
  final List<CardsTrainingEntity> mistakes;
  final String setId;

  const CardsResultPage({
    required this.correctAnswers,
    required this.mistakes,
    super.key,
    required this.setId,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: mistakes.isEmpty || correctAnswers.isEmpty ? 1 : 2,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Semantics(
                    label: S.of(context).exitButton,
                    child: Image.asset('assets/icons/cancel.png'))),
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                S.of(context).results,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9C3AC),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: TabBarView(
                              children: [
                                if (correctAnswers.isNotEmpty)
                                  _buildAnswerList(
                                      correctAnswers, const Color(0xFF85977f)),
                                if (mistakes.isNotEmpty)
                                  _buildAnswerList(
                                      mistakes, const Color(0xFFB70E0E)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 65,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: TabBar(
                              splashFactory: NoSplash.splashFactory,
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              dividerColor: Colors.transparent,
                              isScrollable: false,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                color: const Color(0xFFD9C3AC),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              labelColor: Colors.black,
                              unselectedLabelColor: const Color(0xFFD9C3AC),
                              labelStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              tabs: [
                                if (correctAnswers.isNotEmpty)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Tab(
                                      child: Text(
                                        S.of(context).rightAnswers,
                                        style: TextStyle(
                                            fontSize:
                                                mistakes.isNotEmpty ? 10 : 15),
                                      ),
                                    ),
                                  ),
                                if (mistakes.isNotEmpty)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Tab(
                                      child: Text(
                                        S.of(context).mistakes,
                                        style: TextStyle(
                                            fontSize: correctAnswers.isNotEmpty
                                                ? 10
                                                : 15),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(child: ContinueTrainingButton(
                  onPressed: () {
                    if (setId.isNotEmpty) {
                      BlocProvider.of<TrainingsBloc>(context)
                          .add(FetchSetWordsForCardsTRainings(setId));
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => CardsInProcessPage(setId: setId)));
                    } else {
                      BlocProvider.of<TrainingsBloc>(context)
                          .add(const FetchWordsForCardsTRainings());
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) =>
                              const CardsInProcessPage(setId: "")));
                    }
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerList(List<CardsTrainingEntity> list, Color color) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (ctx, index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        '${list[index].source} -',
                        locale: const Locale('en', 'GB'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: color),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '${list[index].translation}',
                          semanticsLabel: color == Color(0xFFB70E0E)
                              ? S.of(ctx).rightAnswer +
                                  ' ${list[index].translation}'
                              : '${list[index].translation}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: color),
                        ),
                      ),
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
        );
      },
    );
  }
}
