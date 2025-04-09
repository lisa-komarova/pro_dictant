import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_state.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/tw_result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../../../../core/ad_widget.dart';
import '../../domain/entities/tw_training_entity.dart';

class TWInProcessPage extends StatefulWidget {
  final String setId;

  const TWInProcessPage({
    super.key,
    required this.setId,
  });

  @override
  State<TWInProcessPage> createState() => _TWInProcessPageState();
}

class _TWInProcessPageState extends State<TWInProcessPage> {
  int currentWordIndex = 0;
  Map<String, String> answers = {};
  int numberOfAdsShown = 0;
  late int correctSoundId;
  late int wrongSoundId;
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions());

  @override
  void initState() {
    getNumberOfAdsShown();
    initSounds();
    MobileAds.initialize();
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
            } else if (state is TWTrainingLoaded) {
              return _buildWordCard(state.words);
            } else {
              return const SizedBox();
            }
          },
        ));
  }

  Widget _buildWordCard(List<TWTrainingEntity> words) {
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
          child: Text(
            '${currentWordIndex + 1}/${words.length}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Flexible(
          flex: 1,
          child: SizedBox(
            height: 100,
          ),
        ),
        Flexible(
          flex: 2,
          child: Center(
            child: Text(
              words[currentWordIndex].translation,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Column(
            children: [
              ...buildSuggestedAnswers(words),
            ],
          ),
        )
      ],
    );
  }

  void updateCurrentWord(List<TWTrainingEntity> words) {
    if (currentWordIndex + 1 >= words.length) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => TWResultPage(
                answers: answers,
                words: words,
                setId: widget.setId,
              )));
      List<String> toUpdate = [];
      answers.forEach((key, value) async {
        String correctAnswer =
            words.where((element) => element.id == key).toList().first.source;
        if (correctAnswer == value) {
          toUpdate.add(key);
          await pool.play(correctSoundId);
        } else {
          await pool.play(wrongSoundId);
        }
      });
      BlocProvider.of<TrainingsBloc>(context)
          .add(UpdateWordsForTwTRainings(toUpdate));
      return;
    }
    setState(() {
      currentWordIndex++;
    });
  }

  List<Widget> buildSuggestedAnswers(List<TWTrainingEntity> words) {
    List<Widget> answersContainers = [];
    var rng = Random();
    Set<int> randomSequence = {};
    do {
      randomSequence.add(rng.nextInt(4));
    } while (randomSequence.length < 4);

    for (var element in randomSequence) {
      element == 3
          ? answersContainers.add(Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: FilledButton(
                    onPressed: () async {
                      answers[words[currentWordIndex].id] =
                          words[currentWordIndex].source;
                      await pool.play(correctSoundId);
                      updateCurrentWord(words);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFd9c3ac),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: AutoSizeText(
                          words[currentWordIndex].source,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ))
          : answersContainers.add(Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: FilledButton(
                    onPressed: () async {
                      answers[words[currentWordIndex].id] =
                          words[currentWordIndex]
                              .suggestedSourcesList[element]
                              .source;
                      await pool.play(wrongSoundId);
                      updateCurrentWord(words);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFd9c3ac),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: AutoSizeText(
                          words[currentWordIndex]
                              .suggestedSourcesList[element]
                              .source,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
    }
    return answersContainers;
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
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
  }
}
