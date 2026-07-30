import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeatition_result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/ad_widget.dart';
import '../../../../core/platform/auto_speak_prefs.dart';
import '../../../../core/platform/sound_service.dart';
import '../../../../service_locator.dart';
import '../../domain/entities/repeating_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';
import '../widgets/animated_answer_button.dart';

class RepeatitionInProcessPage extends StatefulWidget {
  final String setId;

  const RepeatitionInProcessPage({
    super.key,
    required this.setId,
  });

  @override
  State<RepeatitionInProcessPage> createState() => _CardsInProcessPageState();
}

class _CardsInProcessPageState extends State<RepeatitionInProcessPage> {
  int currentWordIndex = 0;
  Color colorPositive = const Color(0xFFd9c3ac);
  Color colorNegative = const Color(0xFFd9c3ac);
  Color colorNeutral = const Color(0xFFd9c3ac);
  List<RepeatingTrainingEntity> wordsOnTraining = [];
  List<RepeatingTrainingEntity> mistakes = [];
  List<RepeatingTrainingEntity> correctAnswers = [];
  List<RepeatingTrainingEntity> stillLearning = [];
  final FlutterTts flutterTts = FlutterTts();
  bool isPronounceSelected = false;
  bool hideTranslation = true;
  final Color _color = const Color(0xFF85977f);
  int numberOfAdsShown = 0;
  final soundService = sl.get<SoundService>();
  late FocusNode sourceFocusNode;
  bool isAutoSpeakEnabled = false;
  final autoSpeakPrefs = sl.get<AutoSpeakPrefs>();

  @override
  void initState() {
    getNumberOfAdsShown();
    sourceFocusNode = FocusNode();
    _loadAutoSpeak();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(sourceFocusNode);
    });
    super.initState();
  }

  Future<void> _loadAutoSpeak() async {
    final value = await autoSpeakPrefs.getIsEnabled('Repetition');
    if (!mounted) return;
    setState(() {
      isAutoSpeakEnabled = value;
    });
  }

  @override
  void dispose() {
    sourceFocusNode.dispose();
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
                    autoSpeakPrefs.setIsEnabled(
                        'Repetition', isAutoSpeakEnabled);
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
              } else if (state is RepeatingTrainingLoaded) {
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

  Widget _buildWordCard(List<RepeatingTrainingEntity> words) {
    if (currentWordIndex >= words.length) return SizedBox();
    if (isAutoSpeakEnabled && hideTranslation) speak(words[currentWordIndex].source);
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  child: numberOfAdsShown < 3
                      ? BannerAdvertisement(
                          screenWidth:
                              MediaQuery.of(context).size.width.round(),
                        )
                      : null,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${currentWordIndex + 1}/${words.length}',
                    semanticsLabel: S.of(context).wordsRemaining(
                        words.length - (currentWordIndex + 1)),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      wordsOnTraining.addAll(words.sublist(0, currentWordIndex));
                      wordsOnTraining.removeWhere((element) =>
                          correctAnswers.contains(element) ||
                          mistakes.contains(element));
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => RepeatitionResultPage(
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
            const Spacer(),
            Flexible(
              flex: 2,
              child: ExcludeSemantics(
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
            ),
            const Spacer(),
            Flexible(
              flex: 4,
              fit: FlexFit.loose,
              child: Center(
                child: Column(
                  children: [
                    Focus(
                      focusNode: sourceFocusNode,
                      child: Semantics(
                        focused: sourceFocusNode.hasFocus,
                        child: Text(
                          words[currentWordIndex].source,
                          locale: const Locale('en', 'GB'),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Semantics(
                        child: hideTranslation ? GestureDetector(
                          onTap: (){
                            setState(() {
                              hideTranslation = false;
                            });
                          },
                          child: Text(
                            S.of(context).showTranslation,
                            locale: const Locale('ru'),
                            style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: const Color(0xFF85977f)),
                            textAlign: TextAlign.center,
                          ) ,
                        ): Text(
                          words[currentWordIndex].translation,
                          locale: const Locale('ru'),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ) ,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: AnimatedAnswerButton(
                      text: S.of(context).iKnowWontForget,
                      locale: Localizations.localeOf(context),
                      onTap: () {
                        soundService.playCorrect();
                        correctAnswers.add(words[currentWordIndex]);
                        goToNextOrFinish(words);
                      },
                      color: const Color(0xFF85977f),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: AnimatedAnswerButton(
                      text: S.of(context).iKnowMightForget,
                      locale: Localizations.localeOf(context),
                      onTap: () {
                        soundService.playNeutral();
                        goToNextOrFinish(words);
                      },
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: AnimatedAnswerButton(
                      text: S.of(context).iDontRemember,
                      locale: Localizations.localeOf(context),
                      onTap: () {
                        soundService.playWrong();
                        mistakes.add(words[currentWordIndex]);
                        goToNextOrFinish(words);
                      },
                      color: const Color(0xFFB70E0E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
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

  void goToNextOrFinish(List<RepeatingTrainingEntity> words) {
    if (currentWordIndex + 1 >= words.length) {
      stillLearning.addAll(words);
      stillLearning.removeWhere((element) =>
          correctAnswers.contains(element) || mistakes.contains(element));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => RepeatitionResultPage(
            mistakes: mistakes,
            learnt: correctAnswers,
            learning: stillLearning,
            setId: widget.setId,
          ),
        ),
      );

      BlocProvider.of<TrainingsBloc>(context)
          .add(UpdateWordsForRepeatingTRainings(mistakes, correctAnswers));

      return;
    }

    setState(() {
      currentWordIndex++;
      hideTranslation = true;
    });
  }
}
