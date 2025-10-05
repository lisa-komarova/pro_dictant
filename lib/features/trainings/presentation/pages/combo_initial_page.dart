import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/wt_in_process_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import '../../../../core/ad_widget.dart';
import '../../domain/entities/combo_training_entity.dart';
import '../../domain/entities/wt_training_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';

class ComboInitialPage extends StatefulWidget {
  const ComboInitialPage({
    super.key,
  });

  @override
  State<ComboInitialPage> createState() => _ComboInitialPageState();
}

class _ComboInitialPageState extends State<ComboInitialPage> {
  int currentWordIndex = 0;
  final FlutterTts flutterTts = FlutterTts();
  var isPronounceSelected = false;
  final Color _color = const Color(0xFF85977f);
  int numberOfAdsShown = 0;
  final List<ComboTrainingEntity> wordsToLearn = [];
  late int learnSoundId;
  late int passSoundId;
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions());

  @override
  void initState() {
    getNumberOfAdsShown();
    initSounds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
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
            } else if (state is ComboTrainingLoaded) {
              return _buildWordCard(state.words);
            } else {
              return const SizedBox();
            }
          },
        ),
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

  Widget _buildWordCard(List<ComboTrainingEntity> words) {
    if (currentWordIndex >= words.length || wordsToLearn.length >= 5)
      return SizedBox();
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
            '${wordsToLearn.length + 1}/${words.length >= 5 ? 5 : words.length}',
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
          flex: 3,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    words[currentWordIndex].source,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        words[currentWordIndex].translation,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: FilledButton(
                      onPressed: () async {
                        if (currentWordIndex + 1 >= words.length) {
                          finishWorkout(wordsToLearn);
                          return;
                        }
                        await pool.play(passSoundId);
                        setState(() {
                          currentWordIndex++;
                        });
                        if (wordsToLearn.length >= 5) {
                          finishWorkout(wordsToLearn);
                          return;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFd9c3ac),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AutoSizeText(
                              S.of(context).pass,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: FilledButton(
                      onPressed: () async {
                        wordsToLearn.add(words[currentWordIndex]);
                        await pool.play(learnSoundId);
                        if (currentWordIndex + 1 >= words.length) {
                          finishWorkout(wordsToLearn);
                          return;
                        }
                        setState(() {
                          currentWordIndex++;
                        });
                        if (wordsToLearn.length >= 5) {
                          finishWorkout(wordsToLearn);
                          return;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFd9c3ac),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AutoSizeText(
                              S.of(context).learn,
                              textAlign: TextAlign.center,
                            ),
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

  void finishWorkout(List<ComboTrainingEntity> wordsToLearn) {
    final List<WTTrainingEntity> wtWords = [];
    for (var word in wordsToLearn) {
      wtWords.add(WTTrainingEntity(
          id: word.id,
          wordId: word.wordId,
          source: word.source,
          translation: word.translation));
    }
    wtWords.shuffle();

    BlocProvider.of<TrainingsBloc>(context)
        .add(FetchWordsForWtTRainings(words: wtWords));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const WTInProcessPage(
              setId: '',
              isCombo: true,
            )));
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
    learnSoundId = await rootBundle
        .load("assets/sounds/correct.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    passSoundId = await rootBundle
        .load("assets/sounds/neutral.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
  }
}
