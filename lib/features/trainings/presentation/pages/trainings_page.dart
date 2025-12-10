import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/profile/presentation/manager/profile_bloc.dart';
import 'package:pro_dictant/features/profile/presentation/manager/profile_event.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/combo_initial_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeatition_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/tw_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/wt_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/training_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cards_in_process_page.dart';
import 'dictant_in_process_page.dart';
import 'matching_in_process_page.dart';

class TrainingsPage extends StatefulWidget {
  final int goal;
  final bool isTodayCompleted;
  final String setId;
  final String setName;

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
    with WidgetsBindingObserver {
  Duration timeOnApp = const Duration();
  Duration sessionTime = const Duration();
  bool isTodayCompleted = false;
  // NetworkInfoImp networkInfo = NetworkInfoImp(InternetConnectionChecker());
  // bool isConnected = true;
  int numberOfAdsShown = 0;

  // @override
  // void didChangeDependencies() {
  //   checkInternet();
  //   super.didChangeDependencies();
  // }
  Stopwatch? _stopwatch;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    isTodayCompleted = widget.isTodayCompleted;
    WidgetsBinding.instance.addObserver(this);
    getTime().then((_) {
      if (!isTodayCompleted) {
        _startSession();
      }
    });
    getNumberOfAdsShown();
  }

  void _startSession() {
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        sessionTime = _stopwatch?.elapsed ?? Duration.zero;
        if ((timeOnApp + sessionTime) >= Duration(minutes: widget.goal)) {
          BlocProvider.of<ProfileBloc>(context)
              .add(UpdateDayStatistics(date: DateTime.now()));
          BlocProvider.of<ProfileBloc>(context).add(const LoadStatistics());

          timeOnApp = Duration.zero;
          sessionTime = Duration.zero;
          isTodayCompleted = true;

          _stopwatch?.stop();
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _stopwatch?.stop();
      sessionTime = _stopwatch?.elapsed ?? Duration.zero;
      saveTime();
    } else if (state == AppLifecycleState.resumed) {
      if (!isTodayCompleted) {
        getTime().then((_) {
          sessionTime = Duration.zero;
          _startSession();
        });
      }
    }
  }

  @override
  void dispose() {
    saveTime();
    _stopwatch?.stop();
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    var minHeight = 400;
    var comboHeight;
    height -= kToolbarHeight;
    if (widget.setName.isEmpty) {
      height -= 80; // default NavigationBarThemeData.height
    }
    height -= 50;
    height -= !isTodayCompleted ? 50 : 0;
    if (widget.setId.isEmpty) {
      comboHeight = height / 4;
      height -= comboHeight;
    }
    Duration timeLeft =
        Duration(minutes: widget.goal) - (timeOnApp + sessionTime);
    var aspectRatio = (width / 2) / (height / 3);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child:
                  //(isConnected || (numberOfAdsShown >= 3)) ?
                  Column(
                children: [
                  !isTodayCompleted
                      ? SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 10),
                            child: !isTodayCompleted
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
                        )
                      : SizedBox.shrink(),
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
                      child: Column(
                    children: [
                      if (widget.setId.isEmpty)
                        Semantics(
                          label: S.of(context).comboDesc,
                          child: SizedBox(
                            height: comboHeight,
                            child: GestureDetector(
                              child: TrainingCard(
                                trainingName: height > minHeight
                                    ? S.of(context).combo
                                    : '',
                                imageName: 'combo',
                              ),
                              onTap: () {
                                BlocProvider.of<TrainingsBloc>(context)
                                    .add(const FetchWordsForComboTRainings());
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) =>
                                        const ComboInitialPage()));
                              },
                            ),
                          ),
                        ),
                      Expanded(
                        child: GridView.count(
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          crossAxisCount: 2,
                          childAspectRatio: aspectRatio,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            GestureDetector(
                              child: Semantics(
                                label: S.of(context).wordTranslationDesc,
                                child: TrainingCard(
                                  trainingName: height > minHeight
                                      ? S.of(context).wordTranslation
                                      : '',
                                  imageName: 'word-t',
                                ),
                              ),
                              onTap: () {
                                if (widget.setId.isNotEmpty) {
                                  BlocProvider.of<TrainingsBloc>(context).add(
                                      FetchSetWordsForWtTRainings(
                                          widget.setId));
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
                              child: Semantics(
                                label: S.of(context).translationWordDesc,
                                child: TrainingCard(
                                  trainingName: height > minHeight
                                      ? S.of(context).translationWord
                                      : '',
                                  imageName: 't-word',
                                ),
                              ),
                              onTap: () {
                                if (widget.setId.isNotEmpty) {
                                  BlocProvider.of<TrainingsBloc>(context).add(
                                      FetchSetWordsForTwTRainings(
                                          widget.setId));
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
                              child: Semantics(
                                label: S.of(context).matchingWordsDesc,
                                child: TrainingCard(
                                  trainingName: height > minHeight
                                      ? S.of(context).matchingWords
                                      : '',
                                  imageName: 'word_matching',
                                ),
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
                                  BlocProvider.of<TrainingsBloc>(context).add(
                                      const FetchWordsForMatchingTRainings());
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          const MatchingInProcessPage(
                                            setId: '',
                                          )));
                                }
                              },
                            ),
                            GestureDetector(
                              child: Semantics(
                                label: S.of(context).wordCardsDesc,
                                child: TrainingCard(
                                  trainingName: height > minHeight
                                      ? S.of(context).wordCards
                                      : '',
                                  imageName: 'word_cards',
                                ),
                              ),
                              onTap: () {
                                if (widget.setId.isNotEmpty) {
                                  BlocProvider.of<TrainingsBloc>(context).add(
                                      FetchSetWordsForCardsTRainings(
                                          widget.setId));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => CardsInProcessPage(
                                            setId: widget.setId,
                                          )));
                                } else {
                                  BlocProvider.of<TrainingsBloc>(context)
                                      .add(const FetchWordsForCardsTRainings());
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          const CardsInProcessPage(
                                            setId: '',
                                          )));
                                }
                              },
                            ),
                            GestureDetector(
                              child: Semantics(
                                label: S.of(context).dictantDesc,
                                child: TrainingCard(
                                  trainingName: height > minHeight
                                      ? S.of(context).dictant
                                      : '',
                                  imageName: 'dictant',
                                ),
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
                                  BlocProvider.of<TrainingsBloc>(context).add(
                                      const FetchWordsForDictantTRainings());
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          const DictantInProcessPage(
                                            setId: '',
                                          )));
                                }
                              },
                            ),
                            GestureDetector(
                              child: Semantics(
                                label: S.of(context).repeatWordsDesc,
                                child: TrainingCard(
                                  trainingName: height > minHeight
                                      ? S.of(context).repeatWords
                                      : '',
                                  imageName: 'repetition',
                                ),
                              ),
                              onTap: () {
                                if (widget.setId.isNotEmpty) {
                                  BlocProvider.of<TrainingsBloc>(context).add(
                                      FetchSetWordsForRepeatingTRainings(
                                          widget.setId));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => RepeatitionInProcessPage(
                                            setId: widget.setId,
                                          )));
                                } else {
                                  BlocProvider.of<TrainingsBloc>(context).add(
                                      const FetchWordsForRepeatingTRainings());
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          const RepeatitionInProcessPage(
                                            setId: '',
                                          )));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
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
