import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeatition_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/continue_training_button.dart';

import '../../domain/entities/repeating_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../widgets/results_tabbar.dart';

class RepeatitionResultPage extends StatefulWidget {
  final String setId;
  final List<RepeatingTrainingEntity> mistakes;
  final List<RepeatingTrainingEntity> learnt;
  final List<RepeatingTrainingEntity> learning;

  const RepeatitionResultPage({
    required this.setId,
    required this.mistakes,
    required this.learnt,
    required this.learning,
    super.key,
  });

  @override
  State<RepeatitionResultPage> createState() => _RepeatitionResultPageState();
}

class _RepeatitionResultPageState extends State<RepeatitionResultPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [];
    final List<Widget> tabViews = [];

    if (widget.mistakes.isNotEmpty) {
      tabs.add(Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Tab(
          child: Text(
            S.of(context).resetProgress,
            //   style: TextStyle(
            //       fontSize: widget.learnt.isNotEmpty || widget.learning.isNotEmpty
            //           ? 10
            //           : 15),
          ),
        ),
      ));
      tabViews.add(_buildAnswerList(widget.mistakes, const Color(0xFFB70E0E)));
    }
    if (widget.learning.isNotEmpty) {
      tabs.add(Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Tab(
          child: Text(
            widget.learnt.isNotEmpty || widget.mistakes.isNotEmpty
                ? S.of(context).learning
                : S.of(context).leftLearning,
            style: TextStyle(
                fontSize: widget.learnt.isNotEmpty || widget.mistakes.isNotEmpty
                    ? 10
                    : 15),
          ),
        ),
      ));
      tabViews.add(_buildAnswerList(widget.learning, const Color(0xFF85705B)));
    }
    if (widget.learnt.isNotEmpty) {
      tabs.add(Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Tab(
          child: Text(
            S.of(context).learnt,
            /*style: TextStyle(
                fontSize:
                    widget.mistakes.isNotEmpty || widget.learning.isNotEmpty
                        ? 10
                        : 15),*/
          ),
        ),
      ));
      tabViews.add(_buildAnswerList(widget.learnt, const Color(0xFF85977f)));
    }

    return DefaultTabController(
      length: [widget.mistakes, widget.learnt, widget.learning]
          .where((l) => l.isNotEmpty)
          .length,
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: ResultsTabBar(
                    tabs: [
                      if (widget.mistakes.isNotEmpty)
                        S.of(context).resetProgress,
                      if (widget.learning.isNotEmpty)
                        S.of(context).leftLearning,
                      if (widget.learnt.isNotEmpty) S.of(context).learnt,
                    ],
                    pageController: _pageController,
                    selectedIndex: _selectedIndex,
                    dotColors: [
                      if (widget.mistakes.isNotEmpty) const Color(0xFFB70E0E),
                      if (widget.learning.isNotEmpty) const Color(0xff9b856b),
                      if (widget.learnt.isNotEmpty) const Color(0xFF85977f),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9C3AC),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          children: tabViews,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ContinueTrainingButton(
                    onPressed: () {
                      if (widget.setId.isNotEmpty) {
                        BlocProvider.of<TrainingsBloc>(context).add(
                            FetchSetWordsForRepeatingTRainings(widget.setId));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) =>
                                RepeatitionInProcessPage(setId: widget.setId)));
                      } else {
                        BlocProvider.of<TrainingsBloc>(context)
                            .add(const FetchWordsForRepeatingTRainings());
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) =>
                                const RepeatitionInProcessPage(setId: "")));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildAnswerList(List<RepeatingTrainingEntity> list, Color color) {
  return ListView.builder(
    itemCount: list.length,
    itemBuilder: (ctx, index) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        '${list[index].source} -',
                        locale: const Locale('en', 'GB'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: color),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      '${list[index].translation}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: color),
                    ),
                  ),
                ],
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
    },
  );
}
