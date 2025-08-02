import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeating_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/continue_training_button.dart';

import '../../domain/entities/repeating_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';

class RepeatingResultPage extends StatefulWidget {
  final String setId;
  final List<RepeatingTrainingEntity> mistakes;
  final List<RepeatingTrainingEntity> learnt;
  final List<RepeatingTrainingEntity> learning;

  const RepeatingResultPage({
    required this.setId,
    required this.mistakes,
    required this.learnt,
    required this.learning,
    super.key,
  });

  @override
  State<RepeatingResultPage> createState() => _RepeatingResultPageState();
}

class _RepeatingResultPageState extends State<RepeatingResultPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    int tabCount = 0;
    if (widget.mistakes.isNotEmpty) tabCount++;
    if (widget.learnt.isNotEmpty) tabCount++;
    if (widget.learning.isNotEmpty) tabCount++;

    tabController = TabController(
      animationDuration: Duration.zero,
      length: tabCount,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [];
    final List<Widget> tabViews = [];

    if (widget.mistakes.isNotEmpty) {
      tabs.add(Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Tab(text: S.of(context).newWords ),
      ));
      tabViews.add(_buildAnswerList(widget.mistakes, const Color(0xFFB70E0E)));
    }

    if (widget.learnt.isNotEmpty) {
      tabs.add(Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Tab(text: S.of(context).learnt),
      ));
      tabViews.add(_buildAnswerList(widget.learnt, const Color(0xFF85977f)));
    }

    if (widget.learning.isNotEmpty) {
      tabs.add(Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Tab(text: S.of(context).learning),
      ));
      tabViews.add(_buildAnswerList(widget.learning, const Color(0xFFC0A183)));
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Image.asset('assets/icons/cancel.png')),
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
                      margin: const EdgeInsets.only(top: 45),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9C3AC),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: TabBarView(
                            controller: tabController,
                            physics: tabViews.length > 2
                                ? NeverScrollableScrollPhysics()
                                : null,
                            children: tabViews),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TabBar(
                          controller: tabController,
                          splashFactory: NoSplash.splashFactory,
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                          dividerColor: Colors.transparent,
                          isScrollable: false,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: const Color(0xFFD9C3AC),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: const Color(0xFFD9C3AC),
                          labelStyle: Theme.of(context).textTheme.titleMedium,
                          tabs: tabs,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(child: ContinueTrainingButton(
              onPressed: () {
                if (widget.setId.isNotEmpty) {
                  BlocProvider.of<TrainingsBloc>(context)
                      .add(FetchSetWordsForRepeatingTRainings(widget.setId));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) =>
                          RepeatingInProcessPage(setId: widget.setId)));
                } else {
                  BlocProvider.of<TrainingsBloc>(context)
                      .add(const FetchWordsForRepeatingTRainings());
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) =>
                          const RepeatingInProcessPage(setId: "")));
                }
              },
            )),
          ],
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      '${list[index].source} -',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: color),
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
