import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/cards_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/continue_training_button.dart';

import '../../domain/entities/cards_training_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../widgets/results_tabbar.dart';

class CardsResultPage extends StatefulWidget {
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
  State<CardsResultPage> createState() => _CardsResultPageState();
}

class _CardsResultPageState extends State<CardsResultPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> availableTabs = [];
    final List<Color> activeDotColors = [];
    final List<Widget> pageViews = [];

    if (widget.correctAnswers.isNotEmpty) {
      availableTabs.add(S.of(context).rightAnswers);
      activeDotColors.add(const Color(0xFF85977f));
      pageViews.add(
          _buildAnswerList(widget.correctAnswers, const Color(0xFF85977f)));
    }

    if (widget.mistakes.isNotEmpty) {
      availableTabs.add(S.of(context).mistakes);
      activeDotColors.add(const Color(0xFFB70E0E));
      pageViews.add(_buildAnswerList(widget.mistakes, const Color(0xFFB70E0E)));
    }

    if (availableTabs.isEmpty) {
      availableTabs.add('Empty');
      activeDotColors.add(const Color(0xFFE8D7C8));
      pageViews.add(const Center(child: Text('Нет данных')));
    }

    return DefaultTabController(
      length: widget.mistakes.isEmpty || widget.correctAnswers.isEmpty ? 1 : 2,
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
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ResultsTabBar(
                      tabs: availableTabs,
                      pageController: _pageController,
                      selectedIndex: _currentIndex,
                      dotColors: activeDotColors,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFFD9C3AC),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            children:
                                pageViews,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: ContinueTrainingButton(
                      onPressed: () {
                        if (widget.setId.isNotEmpty) {
                          BlocProvider.of<TrainingsBloc>(context)
                              .add(FetchSetWordsForCardsTRainings(widget.setId));
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      CardsInProcessPage(setId: widget.setId)));
                        } else {
                          BlocProvider.of<TrainingsBloc>(context)
                              .add(const FetchWordsForCardsTRainings());
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      const CardsInProcessPage(setId: "")));
                        }
                      },
                    ),
                  ),
                ],
              ),
            )),
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
