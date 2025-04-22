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
  Duration timeOnApp = const Duration();
  Duration sessionTime = const Duration();
  late final AppLifecycleListener _listener;
  final List<String> _states = <String>[];
  late AppLifecycleState? _state;

  // NetworkInfoImp networkInfo = NetworkInfoImp(InternetConnectionChecker());
  // bool isConnected = true;
  int numberOfAdsShown = 0;

  // @override
  // void didChangeDependencies() {
  //   checkInternet();
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    getTime();
    getNumberOfAdsShown();
    //checkInternet();
    if (!widget.isTodayCompleted) {
      _ticker = createTicker((elapsed) {
        sessionTime = elapsed;
        setState(() {
          if ((timeOnApp + sessionTime) >= Duration(minutes: widget.goal)) {
            BlocProvider.of<ProfileBloc>(context)
                .add(UpdateDayStatistics(date: DateTime.now()));
            BlocProvider.of<ProfileBloc>(context).add(const LoadStatistics());
            timeOnApp = const Duration();
            sessionTime = const Duration();
            widget.isTodayCompleted = true;
            _ticker!.stop();
          }
        });
      });
      _ticker!.start();
    }

    super.initState();
    _state = SchedulerBinding.instance.lifecycleState;
    // networkInfo.connectionChecker.onStatusChange
    //     .listen((InternetConnectionStatus status) {
    //   switch (status) {
    //     case InternetConnectionStatus.connected:
    //       setState(() {
    //         isConnected = true;
    //       });
    //       break;
    //     case InternetConnectionStatus.disconnected:
    //       setState(() {
    //         isConnected = false;
    //       });
    //       break;
    //   }
    // });
    _listener = AppLifecycleListener(
      onResume: () {
        getTime();
        _ticker?.start();
      },
      onInactive: () {
        saveTime();
        _ticker?.stop(canceled: false);
      },
      onHide: () => () {
        saveTime();
      },
      onShow: () => () {
        getTime();
      },
      onPause: () => () {
        saveTime();
      },
      onDetach: () => () {
        saveTime();
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
    saveTime();
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
    height -= 50;

    Duration timeLeft =
        Duration(minutes: widget.goal) - (timeOnApp + sessionTime);
    var aspectRatio = (width / 2) / (height / 3);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child:
                  //(isConnected || (numberOfAdsShown >= 3)) ?
                  Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                      child: !widget.isTodayCompleted
                          ? AutoSizeText(
                              timeLeft.inMinutes == widget.goal
                                  ? ""
                                  : S
                                      .of(context)
                                      .timeLeft(timeLeft.inMinutes + 1),
                              textAlign: TextAlign.center,
                            )
                          : null,
                    ),
                  ),
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
                              BlocProvider.of<TrainingsBloc>(context).add(
                                  FetchSetWordsForWtTRainings(widget.setId));
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
                              BlocProvider.of<TrainingsBloc>(context).add(
                                  FetchSetWordsForTwTRainings(widget.setId));
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
                                  FetchSetWordsForDictantTRainings(
                                      widget.setId));
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
                                  builder: (ctx) =>
                                      const RepeatingInProcessPage(
                                        setId: '',
                                      )));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
              // : Center(
              //     child: Text(
              //       S.of(context).noInternetConnection,
              //     ),
              //   ),
              ),
        ),
      ),
    );
  }

  void saveTime() async {
    final prefs = await SharedPreferences.getInstance();
    Duration time = sessionTime + timeOnApp;
    prefs.setString('timeOnApp', time.toString());
  }

  getTime() async {
    final prefs = await SharedPreferences.getInstance();
    String time = prefs.getString('timeOnApp') ?? "";
    timeOnApp = parseDuration(time);
  }

  Duration parseDuration(String s) {
    if (s.isEmpty) return const Duration();
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  getNumberOfAdsShown() async {
    final prefs = await SharedPreferences.getInstance();
    numberOfAdsShown = prefs.getInt('numberOfAdsShown') ?? 0;
  }

// void checkInternet() async {
//   isConnected = await networkInfo.isConnected;
// }
}
