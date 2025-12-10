import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/repeating_result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/ad_widget.dart';
import '../../../../core/platform/auto_speak_prefs.dart';
import '../../../../core/platform/sound_service.dart';
import '../../../../service_locator.dart';
import '../../domain/entities/repeating_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';
import '../widgets/repetition_answer_button.dart';

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
    isAutoSpeakEnabled = await autoSpeakPrefs.getIsEnabled('Repetition');
  }

  @override
  void dispose() {
    sourceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        isAutoSpeakEnabled = false;
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
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
    if (isAutoSpeakEnabled) speak(words[currentWordIndex].source);
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  children: [
                    Text(
                      '${currentWordIndex + 1}/${words.length}',
                      semanticsLabel: S.of(context).wordsRemaining(
                          words.length - (currentWordIndex + 1)),
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
              Flexible(
                flex: 2,
                child: Center(
                  child: Focus(
                    focusNode: sourceFocusNode,
                    child: Semantics(
                      focused: sourceFocusNode.hasFocus,
                      child: Text(
                        words[currentWordIndex].source,
                        locale: const Locale('en'),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const Flexible(
                flex: 1,
                child: SizedBox(
                  height: 100,
                ),
              ),
              Expanded(
                flex: 4,
                child: RepetitionAnswerButtons(
                  onTap: (positive, neutral, negative) {
                    if (positive) {
                      soundService.playCorrect();
                      correctAnswers.add(words[currentWordIndex]);
                    } else if (neutral) {
                      soundService.playNeutral();
                    } else if (negative) {
                      soundService.playWrong();
                      mistakes.add(words[currentWordIndex]);
                    }
                    goToNextOrFinish(words);
                  },
                ),
              ),
            ],
          ),
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
          builder: (ctx) => RepeatingResultPage(
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
    });
  }
}
