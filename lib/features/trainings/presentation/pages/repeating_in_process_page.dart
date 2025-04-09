import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeating_result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import '../../../../core/ad_widget.dart';
import '../../domain/entities/repeating_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';

class RepeatingInProcessPage extends StatefulWidget {
  final String setId;

  const RepeatingInProcessPage({
    super.key,
    required this.setId,
  });

  @override
  State<RepeatingInProcessPage> createState() => _CardsInProcessPageState();
}

class _CardsInProcessPageState extends State<RepeatingInProcessPage> {
  int currentWordIndex = 0;
  Color colorPositive = const Color(0xFFd9c3ac);
  Color colorNegative = const Color(0xFFd9c3ac);
  Color colorNeutral = const Color(0xFFd9c3ac);
  List<RepeatingTrainingEntity> wordsOnTraining = [];
  List<RepeatingTrainingEntity> mistakes = [];
  List<RepeatingTrainingEntity> correctAnswers = [];
  List<RepeatingTrainingEntity> stillLearning = [];
  final FlutterTts flutterTts = FlutterTts();
  var isPronounceSelected = false;
  final Color _color = const Color(0xFF85977f);
  int numberOfAdsShown = 0;
  late int correctSoundId;
  late int wrongSoundId;
  late int neutralSoundId;
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions());

  @override
  void initState() {
    getNumberOfAdsShown();
    initSounds();
    super.initState();
  }

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
      body: BlocBuilder<TrainingsBloc, TrainingsState>(
        builder: (context, state) {
          if (state is TrainingEmpty) {
            return Center(
              child: Text(
                S.of(context).notEnoughWords,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            );
          } else if (state is TrainingLoading) {
            return _loadingIndicator();
          } else if (state is RepeatingTrainingLoaded) {
            return _buildWordCard(state.words);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildWordCard(List<RepeatingTrainingEntity> words) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              child: numberOfAdsShown < 3
                  ? BannerAdvertisement(
                      screenWidth: MediaQuery.of(context).size.width.round(),
                    )
                  : null,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Column(
            children: [
              Text(
                '${currentWordIndex + 1}/${words.length}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  wordsOnTraining.addAll(words);
                  wordsOnTraining.removeWhere((element) =>
                      correctAnswers.contains(element) ||
                      mistakes.contains(element));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => RepeatingResultPage(
                            mistakes: mistakes,
                            learnt: correctAnswers,
                            learning: wordsOnTraining,
                            setId: widget.setId,
                          )));
                  BlocProvider.of<TrainingsBloc>(context).add(
                      UpdateWordsForRepeatingTRainings(
                          mistakes, correctAnswers));
                },
                child: Text(
                  S.of(context).endTrainings,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: const Color(0xFF85977f)),
                ),
              ),
            ],
          ),
        ),
        const Flexible(
          flex: 1,
          child: SizedBox(
            height: 100,
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              speak(words[currentWordIndex].source);
            },
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: Image.asset(
                'assets/icons/pronounce.png',
                width: 80,
                height: 80,
                color: _color,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Center(
            child: Text(
              words[currentWordIndex].source,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        colorPositive = const Color(0xFF85977f);
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        colorPositive = const Color(0xFFd9c3ac);
                      });
                    },
                    onVerticalDragStart: (details) {
                      setState(() {
                        colorPositive = const Color(0xFFd9c3ac);
                      });
                    },
                    onHorizontalDragStart: (details) {
                      setState(() {
                        colorPositive = const Color(0xFFd9c3ac);
                      });
                    },
                    onTap: () async {
                      await pool.play(correctSoundId);
                      correctAnswers.add(words[currentWordIndex]);
                      if (currentWordIndex + 1 >= words.length) {
                        stillLearning.addAll(words);
                        stillLearning.removeWhere((element) =>
                            correctAnswers.contains(element) ||
                            mistakes.contains(element));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => RepeatingResultPage(
                                  mistakes: mistakes,
                                  learnt: correctAnswers,
                                  learning: stillLearning,
                                  setId: widget.setId,
                                )));
                        BlocProvider.of<TrainingsBloc>(context).add(
                            UpdateWordsForRepeatingTRainings(
                                mistakes, correctAnswers));
                        return;
                      }

                      setState(() {
                        currentWordIndex++;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colorPositive,
                      ),
                      height: 100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AutoSizeText(
                            S.of(context).iKnowWontForget,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        colorNeutral = const Color(0xFFffffff);
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        colorNeutral = const Color(0xFFd9c3ac);
                      });
                    },
                    onVerticalDragStart: (details) {
                      setState(() {
                        colorNeutral = const Color(0xFFd9c3ac);
                      });
                    },
                    onHorizontalDragStart: (details) {
                      setState(() {
                        colorNeutral = const Color(0xFFd9c3ac);
                      });
                    },
                    onTap: () async {
                      await pool.play(neutralSoundId);
                      if (currentWordIndex + 1 >= words.length) {
                        stillLearning.addAll(words);
                        stillLearning.removeWhere((element) =>
                            correctAnswers.contains(element) ||
                            mistakes.contains(element));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => RepeatingResultPage(
                                  mistakes: mistakes,
                                  learnt: correctAnswers,
                                  learning: stillLearning,
                                  setId: widget.setId,
                                )));
                        BlocProvider.of<TrainingsBloc>(context).add(
                            UpdateWordsForRepeatingTRainings(
                                mistakes, correctAnswers));
                        return;
                      }
                      setState(() {
                        currentWordIndex++;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colorNeutral,
                      ),
                      height: 100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AutoSizeText(
                            S.of(context).iKnowMightForget,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        colorNegative = const Color(0xFFB70E0E);
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        colorNegative = const Color(0xFFd9c3ac);
                      });
                    },
                    onVerticalDragStart: (details) {
                      setState(() {
                        colorNegative = const Color(0xFFd9c3ac);
                      });
                    },
                    onHorizontalDragStart: (details) {
                      setState(() {
                        colorNegative = const Color(0xFFd9c3ac);
                      });
                    },
                    onTap: () async {
                      await pool.play(wrongSoundId);
                      mistakes.add(words[currentWordIndex]);
                      if (currentWordIndex + 1 >= words.length) {
                        stillLearning.addAll(words);
                        stillLearning.removeWhere((element) =>
                            correctAnswers.contains(element) ||
                            mistakes.contains(element));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => RepeatingResultPage(
                                  mistakes: mistakes,
                                  learnt: correctAnswers,
                                  learning: stillLearning,
                                  setId: widget.setId,
                                )));
                        BlocProvider.of<TrainingsBloc>(context).add(
                            UpdateWordsForRepeatingTRainings(
                                mistakes, correctAnswers));
                        return;
                      }
                      setState(() {
                        currentWordIndex++;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colorNegative,
                      ),
                      height: 100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AutoSizeText(
                            S.of(context).iDontRemember,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Flexible(
          flex: 1,
          child: SizedBox(
            height: 100,
          ),
        ),
      ],
    );
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage('en-GB');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  getNumberOfAdsShown() async {
    final prefs = await SharedPreferences.getInstance();
    numberOfAdsShown = prefs.getInt('numberOfAdsShown') ?? 0;
  }

  void initSounds() async {
    correctSoundId = await rootBundle
        .load("assets/sounds/correct.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    wrongSoundId = await rootBundle
        .load("assets/sounds/wrong.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    neutralSoundId = await rootBundle
        .load("assets/sounds/neutral.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
  }
}
