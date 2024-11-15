import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/profile/presentation/manager/profile_bloc.dart';
import 'package:pro_dictant/features/profile/presentation/manager/profile_event.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeating_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/tw_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/wt_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/training_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cards_in_process_page.dart';
import 'dictant_in_process_page.dart';
import 'matching_in_process_page.dart';

class TrainingsPage extends StatefulWidget {
  final int goal;
  bool isTodayCompleted;

  TrainingsPage(
      {required this.goal, required this.isTodayCompleted, super.key});

  @override
  State<TrainingsPage> createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage>
    with TickerProviderStateMixin {
  Ticker? _ticker;
  int timeOnApp = 0;
  int sessionTime = 0;
  late final AppLifecycleListener _listener;
  final List<String> _states = <String>[];
  late AppLifecycleState? _state;

  @override
  void initState() {
    getTime();
    if (!widget.isTodayCompleted) {
      _ticker = createTicker((elapsed) {
        // 4. update state
        sessionTime = elapsed.inMinutes;
        setState(() {
          if ((timeOnApp + sessionTime) >= widget.goal) {
            BlocProvider.of<ProfileBloc>(context)
                .add(UpdateDayStatistics(date: DateTime.now()));
            timeOnApp = 0;
            sessionTime = 0;
            widget.isTodayCompleted = true;
            _ticker!.stop();
          }
        });
      });
      _ticker!.start();
    }
    super.initState();
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      //     onShow: () => _handleTransition('show'),
      onResume: () {
        getTime();
        _ticker?.start();
      },
//      onHide: () => _handleTransition('hide'),
      onInactive: () {
        saveTime(timeOnApp + sessionTime);
        _ticker?.stop(canceled: false);
      },
      //     onPause: () => _handleTransition('pause'),
      onDetach: () => () {
        saveTime(timeOnApp + sessionTime);
      },
      onRestart: () => () {
        getTime();
      },
      // This fires for each state change. Callbacks above fire only for
      // specific state transitions.
      onStateChange: _handleStateChange,
    );
    if (_state != null) {
      _states.add(_state!.name);
    }
  }

  @override
  void dispose() {
    saveTime(timeOnApp + sessionTime);
    _ticker?.dispose();
    _listener.dispose();
    super.dispose();
  }

  void _handleStateChange(AppLifecycleState state) {
    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              (!widget.isTodayCompleted)
                  ? SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'до выполнения цели осталось : ${widget.goal - (timeOnApp + sessionTime)} минут'),
                      ),
                    )
                  : const SizedBox(
                      height: 100,
                    ),
              Expanded(
                child: GridView.count(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  children: <Widget>[
                    GestureDetector(
                      child: const TrainingCard(
                        trainingName: 'слово-перевод',
                        imageName: 'word-t',
                      ),
                      onTap: () {
                        BlocProvider.of<TrainingsBloc>(context)
                            .add(const FetchWordsForWtTRainings());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const WTInProcessPage()));
                      },
                    ),
                    GestureDetector(
                      child: const TrainingCard(
                        trainingName: 'перевод-слово',
                        imageName: 't-word',
                      ),
                      onTap: () {
                        BlocProvider.of<TrainingsBloc>(context)
                            .add(const FetchWordsForTwTRainings());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const TWInProcessPage()));
                      },
                    ),
                    GestureDetector(
                      child: const TrainingCard(
                        trainingName: 'соответствие',
                        imageName: 'word_matching',
                      ),
                      onTap: () {
                        BlocProvider.of<TrainingsBloc>(context)
                            .add(const FetchWordsForMatchingTRainings());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const MatchingInProcessPage()));
                      },
                    ),
                    GestureDetector(
                      child: const TrainingCard(
                        trainingName: 'карточки',
                        imageName: 'sprint',
                      ),
                      onTap: () {
                        BlocProvider.of<TrainingsBloc>(context)
                            .add(const FetchWordsForCardsTRainings());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const CardsInProcessPage()));
                      },
                    ),
                    GestureDetector(
                      child: const TrainingCard(
                        trainingName: 'диктант',
                        imageName: 'dictant',
                      ),
                      onTap: () {
                        BlocProvider.of<TrainingsBloc>(context)
                            .add(const FetchWordsForDictantTRainings());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const DictantInProcessPage()));
                      },
                    ),
                    GestureDetector(
                      child: const TrainingCard(
                        trainingName: 'повторение',
                        imageName: 'repetition',
                      ),
                      onTap: () {
                        BlocProvider.of<TrainingsBloc>(context)
                            .add(const FetchWordsForRepeatingTRainings());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const RepeatingInProcessPage()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveTime(int time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('timeOnApp', time);
  }

  getTime() async {
    final prefs = await SharedPreferences.getInstance();
    timeOnApp = prefs.getInt('timeOnApp') ?? 0;
  }
}
