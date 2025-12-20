import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/domain/entities/cards_training_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/ad_widget.dart';
import '../../../../core/platform/auto_speak_prefs.dart';
import '../../../../core/platform/sound_service.dart';
import '../../../../service_locator.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';
import '../widgets/animated_ answer_button.dart';
import 'cards_result_page.dart';

class CardsInProcessPage extends StatefulWidget {
  final String setId;
  const CardsInProcessPage({
    super.key,
    required this.setId,
  });

  @override
  State<CardsInProcessPage> createState() => _CardsInProcessPageState();
}

class _CardsInProcessPageState extends State<CardsInProcessPage> {
  int currentWordIndex = 0;
  List<String> suggestedAnswer = [];
  List<CardsTrainingEntity> correctAnswers = [];
  List<CardsTrainingEntity> mistakes = [];
  final FlutterTts flutterTts = FlutterTts();
  var isPronounceSelected = false;
  final Color _color = const Color(0xFF85977f);
  int numberOfAdsShown = 0;
  final soundService = sl.get<SoundService>();
  late FocusNode wordFocusNode;
  bool isAutoSpeakEnabled = false;
  final autoSpeakPrefs = sl.get<AutoSpeakPrefs>();

  @override
  void initState() {
    getNumberOfAdsShown();
    wordFocusNode = FocusNode();
    _loadAutoSpeak();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        wordFocusNode.requestFocus();
      }
    });
    super.initState();
  }

  Future<void> _loadAutoSpeak() async {
    final value = await autoSpeakPrefs.getIsEnabled('Cards');
    if (!mounted) return;
    setState(() {
      isAutoSpeakEnabled = value;
    });
  }

  @override
  void dispose() {
    wordFocusNode.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        isAutoSpeakEnabled = false;
        await flutterTts.stop();
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () async {
                  await flutterTts.stop();
                  return Navigator.of(context).pop();
                },
                icon: Semantics(
                    label: S.of(context).exitButton,
                    child: Image.asset('assets/icons/cancel.png'))),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isAutoSpeakEnabled = !isAutoSpeakEnabled;
                    });
                    autoSpeakPrefs.setIsEnabled('Cards', isAutoSpeakEnabled);
                  },
                  icon: Semantics(
                      label: isAutoSpeakEnabled
                          ? S.of(context).turnAutoSpeakOff
                          : S.of(context).turnAutoSpeakOn,
                      child: isAutoSpeakEnabled
                          ? Image.asset(
                              'assets/icons/announce_word_activated.png')
                          : Image.asset(
                              'assets/icons/announce_word_not_activated.png')))
            ],
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
              } else if (state is CardsTrainingLoaded) {
                return _buildWordCard(state.words);
              } else {
                return const SizedBox();
              }
            },
          ),
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

  Widget _buildWordCard(List<CardsTrainingEntity> words) {
    if (currentWordIndex >= words.length) return SizedBox();
    if (suggestedAnswer.isEmpty) {
      suggestedAnswer.add(words[currentWordIndex].translation);
      suggestedAnswer.add(words[currentWordIndex].wrongTranslation);
      suggestedAnswer.shuffle();
    }
    if (isAutoSpeakEnabled) speak(words[currentWordIndex].source);
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
            semanticsLabel: S
                .of(context)
                .wordsRemaining(words.length - (currentWordIndex + 1)),
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
              child: Semantics(
                label: S.of(context).speakButton,
                child: Image.asset(
                  'assets/icons/pronounce.png',
                  width: 80,
                  height: 80,
                  color: _color,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Focus(
                focusNode: wordFocusNode,
                child: Text(
                  words[currentWordIndex].source,
                  locale: const Locale('en', 'GB'),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: AnimatedAnswerButton(
                      locale: const Locale('ru'),
                      text: suggestedAnswer.first,
                      color: suggestedAnswer.first !=
                              words[currentWordIndex].translation
                          ? const Color(0xFFB70E0E)
                          : const Color(0xFF85977f),
                      onTap: () async {
                        final isCorrect = suggestedAnswer.first ==
                            words[currentWordIndex].translation;

                        if (isCorrect) {
                          soundService.playCorrect();
                          correctAnswers.add(words[currentWordIndex]);
                        } else {
                          soundService.playWrong();
                          mistakes.add(words[currentWordIndex]);
                        }

                        if (currentWordIndex + 1 >= words.length) {
                          finishWorkout();
                          return;
                        }

                        setState(() {
                          currentWordIndex++;
                          suggestedAnswer = [];
                        });
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: AnimatedAnswerButton(
                      locale: const Locale('ru'),
                      text: suggestedAnswer.last,
                      color: suggestedAnswer.last !=
                              words[currentWordIndex].translation
                          ? const Color(0xFFB70E0E)
                          : const Color(0xFF85977f),
                      onTap: () async {
                        final isCorrect = suggestedAnswer.last ==
                            words[currentWordIndex].translation;

                        if (isCorrect) {
                          soundService.playCorrect();
                          correctAnswers.add(words[currentWordIndex]);
                        } else {
                          soundService.playWrong();
                          mistakes.add(words[currentWordIndex]);
                        }

                        if (currentWordIndex + 1 >= words.length) {
                          finishWorkout();
                          return;
                        }

                        setState(() {
                          currentWordIndex++;
                          suggestedAnswer = [];
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void finishWorkout() {
    final wordsSet = correctAnswers.map((e) => e.id).toSet();
    Set<String> mistakesSet = mistakes.map((e) => e.id).toSet();
    correctAnswers.retainWhere((x) => wordsSet.remove(x.id));
    mistakes.retainWhere((element) => mistakesSet.remove(element.id));
    mistakesSet = mistakes.map((e) => e.id).toSet();
    correctAnswers.removeWhere((element) => mistakesSet.remove(element.id));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => CardsResultPage(
              correctAnswers: correctAnswers,
              mistakes: mistakes,
              setId: widget.setId,
            )));
    BlocProvider.of<TrainingsBloc>(context)
        .add(UpdateWordsForCardsTRainings(correctAnswers));
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage('en-GB');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text, focus: false);
  }

  getNumberOfAdsShown() async {
    final prefs = await SharedPreferences.getInstance();
    numberOfAdsShown = prefs.getInt('numberOfAdsShown') ?? 0;
  }
}
