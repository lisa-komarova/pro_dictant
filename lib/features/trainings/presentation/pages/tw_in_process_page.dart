import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_state.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/tw_result_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/wt_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/answer_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import '../../../../core/ad_widget.dart';
import '../../domain/entities/dictant_training_entity.dart';
import '../../domain/entities/tw_training_entity.dart';
import '../manager/provider/combo_training_session.dart';
import 'combo_result_page.dart';
import 'dictant_in_process_page.dart';

class TWInProcessPage extends StatefulWidget {
  final String setId;
  final bool isCombo;

  const TWInProcessPage({
    super.key,
    required this.setId,
    this.isCombo = false,
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
                final session = context.read<ComboTrainingSession>();
                session.reset();
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
    if (currentWordIndex >= words.length) return SizedBox();
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
      if (widget.isCombo) {
        final session = context.read<ComboTrainingSession>();
        final wrongWordsFromPreviousTraining;
        if (session.correctAnswers['dictantTraining']!.toList().isEmpty &&
            session.dictantWrongAnswers.isEmpty) {
          final List<DictantTrainingEntity> dictantWords = [];
          for (var word in words) {
            dictantWords.add(DictantTrainingEntity(
                id: word.id,
                source: word.source,
                translation: word.translation));
          }
          dictantWords.shuffle();
          BlocProvider.of<TrainingsBloc>(context).add(
              FetchWordsForDictantTRainings(
                  isCombo: true, words: dictantWords));
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => DictantInProcessPage(
                    setId: widget.setId,
                    isCombo: true,
                  )));
          return;
        } else if (session.dictantWrongAnswers.toList().isNotEmpty) {
          wrongWordsFromPreviousTraining = session.dictantWrongAnswers.toList();
          wrongWordsFromPreviousTraining.shuffle();
          BlocProvider.of<TrainingsBloc>(context).add(
              FetchWordsForDictantTRainings(
                  words: wrongWordsFromPreviousTraining));
          session.resetDictantWrongAnswers();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => const DictantInProcessPage(
                    setId: '',
                    isCombo: true,
                  )));
          return;
        } else if (session.wtWrongAnswers.toList().isNotEmpty) {
          wrongWordsFromPreviousTraining = session.wtWrongAnswers.toList();
          wrongWordsFromPreviousTraining.shuffle();
          BlocProvider.of<TrainingsBloc>(context).add(
              FetchWordsForWtTRainings(words: wrongWordsFromPreviousTraining));
          session.resetWtWrongAnswers();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => const WTInProcessPage(
                    setId: '',
                    isCombo: true,
                  )));
          return;
        } else if (session.twWrongAnswers.toList().isNotEmpty) {
          wrongWordsFromPreviousTraining = session.twWrongAnswers.toList();
          wrongWordsFromPreviousTraining.shuffle();
          BlocProvider.of<TrainingsBloc>(context).add(
              FetchWordsForTwTRainings(words: wrongWordsFromPreviousTraining));
          session.resetTwWrongAnswers();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => const TWInProcessPage(
                    setId: '',
                    isCombo: true,
                  )));
          return;
        } else {
          final Set<(String, String)> allWordsSet = {};
          final List<WTTrainingEntity> wtInitialWrongAnswers =
              session.wtInitialWrongAnswers.toList();
          final List<TWTrainingEntity> twInitialWrongAnswers =
              session.twInitialWrongAnswers.toList();
          final List<DictantTrainingEntity> dictantInitialWrongAnswers =
              session.dictantInitialWrongAnswers.toList();

          for (var tuple in session.correctAnswers['wtTraining']!) {
            allWordsSet.add((tuple.$1, tuple.$2));
          }
          final String wtIdsToUpdate = session.correctAnswers["wtTraining"]!
              .where((item) => !wtInitialWrongAnswers.any((wrong) =>
                  wrong.source == item.$1 && wrong.translation == item.$2))
              .map((e) => "'${e.$3}'")
              .join(', ');
          final String twIdsToUpdate = session.correctAnswers["wtTraining"]!
              .where((item) => !twInitialWrongAnswers.any((wrong) =>
                  wrong.source == item.$1 && wrong.translation == item.$2))
              .map((e) => "'${e.$3}'")
              .join(', ');
          final String dictantIdsToUpdate = session
              .correctAnswers["wtTraining"]!
              .where((item) => !dictantInitialWrongAnswers.any((wrong) =>
                  wrong.source == item.$1 && wrong.translation == item.$2))
              .map((e) => "'${e.$3}'")
              .join(', ');
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => ComboResultPage(
                    allWords: allWordsSet.toList(),
                    twInitialWrongAnswers: twInitialWrongAnswers,
                    wtInitialWrongAnswers: wtInitialWrongAnswers,
                    dictantInitialWrongAnswers: dictantInitialWrongAnswers,
                  )));
          BlocProvider.of<TrainingsBloc>(context).add(
              UpdateWordsForComboTRainings(
                  wtIdstoUpdate: wtIdsToUpdate,
                  twIdstoUpdate: twIdsToUpdate,
                  dictantIdstoUpdate: dictantIdsToUpdate));
          session.reset();
          return;
        }
      } else {
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
    }
    setState(() {
      currentWordIndex++;
    });
  }

  List<Widget> buildSuggestedAnswers(List<TWTrainingEntity> words) {
    if (currentWordIndex >= words.length) return [];
    List<Widget> answersContainers = [];
    final session = context.read<ComboTrainingSession>();
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
                    child: AnswerButton(
                        onPressed: () async {
                          answers[words[currentWordIndex].id] =
                              words[currentWordIndex].source;
                          if (widget.isCombo) {
                            session.addCorrect('twTraining', (
                              words[currentWordIndex].source,
                              words[currentWordIndex].translation,
                              words[currentWordIndex].id,
                            ));
                            session.removeTwWrong(words[currentWordIndex]);
                          }
                          await pool.play(correctSoundId);
                          updateCurrentWord(words);
                        },
                        text: words[currentWordIndex].source)),
              ),
            ))
          : answersContainers.add(Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: AnswerButton(
                        onPressed: () async {
                          answers[words[currentWordIndex].id] =
                              words[currentWordIndex]
                                  .suggestedSourcesList[element]
                                  .source;
                          if (widget.isCombo) {
                            session.addTwWrong(words[currentWordIndex]);
                          }
                          await pool.play(wrongSoundId);
                          updateCurrentWord(words);
                        },
                        text: words[currentWordIndex]
                            .suggestedSourcesList[element]
                            .source)),
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
