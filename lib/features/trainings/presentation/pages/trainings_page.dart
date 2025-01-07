import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
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
  String setId;
  String setName;

  TrainingsPage({
    required this.goal,
    required this.isTodayCompleted,
    this.setId = '',
    this.setName = '',
    super.key,
  });

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
        sessionTime = elapsed.inMinutes;
        setState(() {
          if ((timeOnApp + sessionTime) >= widget.goal) {
            BlocProvider.of<ProfileBloc>(context)
                .add(UpdateDayStatistics(date: DateTime.now()));
            BlocProvider.of<ProfileBloc>(context).add(const LoadStatistics());
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
      onResume: () {
        getTime();
        _ticker?.start();
      },
      onInactive: () {
        saveTime(timeOnApp + sessionTime);
        _ticker?.stop(canceled: false);
      },
      onDetach: () => () {
        saveTime(timeOnApp + sessionTime);
      },
      onRestart: () => () {
        getTime();
      },
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
    var size = MediaQuery.of(context).size;
    final safePadding = MediaQuery.paddingOf(context).top;
    var width = size.width;
    var height = size.height;
    height -= kToolbarHeight;
    if (widget.setName.isEmpty) {
      height -= kBottomNavigationBarHeight;
    }
    height -= safePadding;
    height -= 50;
    if (!widget.isTodayCompleted) {
      height -= 50;
    }
    int timeLeft = widget.goal - (timeOnApp + sessionTime);
    var aspectRatio = (width / 2) / (height / 3);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                (!widget.isTodayCompleted)
                    ? SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 10),
                          child: AutoSizeText(
                            S.of(context).timeLeft(timeLeft),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                (widget.setName.isNotEmpty)
                    ? SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: AutoSizeText(
                              S.of(context).currentlyLearning(widget.setName),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: AutoSizeText(
                              S.of(context).currentlyLearning(
                                  S.of(context).myDictionary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                Flexible(
                  child: GridView.count(
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2,
                    childAspectRatio: aspectRatio,
                    shrinkWrap: true,
                    children: <Widget>[
                      GestureDetector(
                        child: TrainingCard(
                          trainingName: S.of(context).wordTranslation,
                          imageName: 'word-t',
                        ),
                        onTap: () {
                          if (widget.setId.isNotEmpty) {
                            BlocProvider.of<TrainingsBloc>(context)
                                .add(FetchSetWordsForWtTRainings(widget.setId));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => WTInProcessPage(
                                      setId: widget.setId,
                                    )));
                          } else {
                            BlocProvider.of<TrainingsBloc>(context)
                                .add(const FetchWordsForWtTRainings());
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const WTInProcessPage(
                                      setId: '',
                                    )));
                          }
                        },
                      ),
                      GestureDetector(
                        child: TrainingCard(
                          trainingName: S.of(context).translationWord,
                          imageName: 't-word',
                        ),
                        onTap: () {
                          if (widget.setId.isNotEmpty) {
                            BlocProvider.of<TrainingsBloc>(context)
                                .add(FetchSetWordsForTwTRainings(widget.setId));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => TWInProcessPage(
                                      setId: widget.setId,
                                    )));
                          } else {
                            BlocProvider.of<TrainingsBloc>(context)
                                .add(const FetchWordsForTwTRainings());
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const TWInProcessPage(
                                      setId: '',
                                    )));
                          }
                        },
                      ),
                      GestureDetector(
                        child: TrainingCard(
                          trainingName: S.of(context).matchingWords,
                          imageName: 'word_matching',
                        ),
                        onTap: () {
                          if (widget.setId.isNotEmpty) {
                            BlocProvider.of<TrainingsBloc>(context).add(
                                FetchSetWordsForMatchingTRainings(
                                    widget.setId));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => MatchingInProcessPage(
                                      setId: widget.setId,
                                    )));
                          } else {
                            BlocProvider.of<TrainingsBloc>(context)
                                .add(const FetchWordsForMatchingTRainings());
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const MatchingInProcessPage(
                                      setId: '',
                                    )));
                          }
                        },
                      ),
                      GestureDetector(
                        child: TrainingCard(
                          trainingName: S.of(context).wordCards,
                          imageName: 'sprint',
                        ),
                        onTap: () {
                          if (widget.setId.isNotEmpty) {
                            BlocProvider.of<TrainingsBloc>(context).add(
                                FetchSetWordsForCardsTRainings(widget.setId));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => CardsInProcessPage(
                                      setId: widget.setId,
                                    )));
                          } else {
                            BlocProvider.of<TrainingsBloc>(context)
                                .add(const FetchWordsForCardsTRainings());
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const CardsInProcessPage(
                                      setId: '',
                                    )));
                          }
                        },
                      ),
                      GestureDetector(
                        child: TrainingCard(
                          trainingName: S.of(context).dictant,
                          imageName: 'dictant',
                        ),
                        onTap: () {
                          if (widget.setId.isNotEmpty) {
                            BlocProvider.of<TrainingsBloc>(context).add(
                                FetchSetWordsForDictantTRainings(widget.setId));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => DictantInProcessPage(
                                      setId: widget.setId,
                                    )));
                          } else {
                            BlocProvider.of<TrainingsBloc>(context)
                                .add(const FetchWordsForDictantTRainings());
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const DictantInProcessPage(
                                      setId: '',
                                    )));
                          }
                        },
                      ),
                      GestureDetector(
                        child: TrainingCard(
                          trainingName: S.of(context).repeatWords,
                          imageName: 'repetition',
                        ),
                        onTap: () {
                          if (widget.setId.isNotEmpty) {
                            BlocProvider.of<TrainingsBloc>(context).add(
                                FetchSetWordsForRepeatingTRainings(
                                    widget.setId));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => RepeatingInProcessPage(
                                      setId: widget.setId,
                                    )));
                          } else {
                            BlocProvider.of<TrainingsBloc>(context)
                                .add(const FetchWordsForRepeatingTRainings());
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const RepeatingInProcessPage(
                                      setId: '',
                                    )));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
