import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/dictant_result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import '../../../../core/ad_widget.dart';
import '../../domain/entities/dictant_training_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';

class DictantInProcessPage extends StatefulWidget {
  final String setId;

  const DictantInProcessPage({
    super.key,
    required this.setId,
  });

  @override
  State<DictantInProcessPage> createState() => _DictantInProcessPageState();
}

class _DictantInProcessPageState extends State<DictantInProcessPage> {
  int currentWordIndex = 0;
  int currentLetterIndex = 0;
  int attempts = 0;
  int maxAttempts = 3;
  List<Color> colors = [];
  String correctAnswer = '';
  bool isHintSelected = false;
  List<DictantTrainingEntity> words = [];
  List<DictantTrainingEntity> correctAnswers = [];
  List<DictantTrainingEntity> mistakes = [];
  List<String> suggestedLetters = [];
  Color focusBorderColor = const Color(0xff5e6b5a);
  final wordController = TextEditingController();
  int numberOfAdsShown = 0;
  late int correctSoundId;
  late int wrongSoundId;
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions());

  @override
  void initState() {
    initSounds();
    getNumberOfAdsShown();
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
          } else if (state is DictantTrainingLoaded) {
            if (words.isEmpty) {
              words.addAll(state.words);
            }
            return _buildWordCard(state.words);
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: !isHintSelected
          ? FloatingActionButton(
              onPressed: () {
                wordController.text = '';
                setState(() {
                  attempts = 0;
                  isHintSelected = true;
                });
              },
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              backgroundColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                    height: 35,
                    width: 35,
                    child: Image.asset('assets/icons/hint.png')),
              ),
            )
          : null,
    );
  }

  Widget _buildWordCard(List<DictantTrainingEntity> words) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
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
        Flexible(
          flex: isHintSelected ? 1 : 2,
          child: Text(
            '${currentWordIndex + 1}/${words.length}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Flexible(
          flex: isHintSelected ? 1 : 3,
          child: Center(
            child: AutoSizeText(
              words[currentWordIndex].translation,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          flex: 9,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  !isHintSelected
                      ? Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              height: 80,
                              child: TextFormField(
                                controller: wordController,
                                textInputAction: TextInputAction.go,
                                keyboardType: TextInputType.text,
                                enableSuggestions: false,
                                style: const TextStyle(fontFamily: 'Roboto'),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                      color: Color(0xFFd9c3ac),
                                      width: 3,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: focusBorderColor, width: 3.0),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : _buildWordBricks(words[currentWordIndex]),
                  !isHintSelected
                      ? Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                if (wordController.text
                                        .toLowerCase()
                                        .replaceAll(' ', '') ==
                                    words[currentWordIndex]
                                        .source
                                        .toLowerCase()
                                        .replaceAll(' ', '')) {
                                  if (!mistakes
                                      .contains(words[currentWordIndex])) {
                                    await pool.play(correctSoundId);
                                    correctAnswers.add(words[currentWordIndex]);
                                    focusBorderColor = const Color(0xFF85977f);
                                  }
                                  wordController.text = '';
                                  updateCurrentWord();
                                } else {
                                  if (attempts + 1 < maxAttempts - 1) {
                                    setState(() {
                                      attempts++;
                                      focusBorderColor =
                                          const Color(0xFFB70E0E);
                                    });
                                  } else {
                                    await pool.play(wrongSoundId);
                                    mistakes.add(words[currentWordIndex]);
                                    updateCurrentWord();
                                  }
                                  wordController.text = '';
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFF85977f),
                                ),
                                height: 50,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: FittedBox(
                                      child: Text(
                                        S.of(context).checkWord,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.hachiMaruPop(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void updateCurrentWord() {
    if (currentWordIndex == words.length - 1) {
      final wordsSet = correctAnswers.map((e) => e.id).toSet();
      Set<String> mistakesSet = mistakes.map((e) => e.id).toSet();
      correctAnswers.retainWhere((x) => wordsSet.remove(x.id));
      mistakes.retainWhere((element) => mistakesSet.remove(element.id));
      mistakesSet = mistakes.map((e) => e.id).toSet();
      correctAnswers.removeWhere((element) => mistakesSet.remove(element.id));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => DictantResultPage(
                correctAnswers: correctAnswers,
                mistakes: mistakes,
                setId: widget.setId,
              )));
      BlocProvider.of<TrainingsBloc>(context)
          .add(UpdateWordsForDictantTRainings(correctAnswers));
      return;
    }
    focusBorderColor = const Color(0xFF85977f);
    isHintSelected = false;
    correctAnswer = '';
    suggestedLetters = [];
    currentLetterIndex = 0;
    attempts = 0;
    colors = [];
    setState(() {
      currentWordIndex++;
    });
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _buildWordBricks(DictantTrainingEntity word) {
    if (suggestedLetters.isEmpty) fillLetters(word);
    return Flexible(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: _buildBoxesForLetters(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: _buildBoxesWithLetters(word),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fillLetters(DictantTrainingEntity word) {
    String str;
    if (word.source.characters.last == ' ') {
      str = word.source.substring(0, word.source.length - 1);
    } else {
      str = word.source;
    }
    List<String> searchKeywords =
        List<String>.generate(str.length, (index) => str[index]);
    for (int i = 0; i < searchKeywords.length; i++) {
      colors.add(const Color(0xFFd9c3ac));
    }
    searchKeywords.shuffle();
    correctAnswer = str;
    suggestedLetters.addAll(searchKeywords);
  }

  List<Widget> _buildBoxesForLetters() {
    final List<Widget> boxesForLetters = [];
    for (int index = 0; index < suggestedLetters.length; index++) {
      boxesForLetters.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFd9c3ac),
            ),
          ),
          child: Center(
            child: currentLetterIndex > index
                ? Text(correctAnswer[index])
                : const Text(''),
          ),
        ),
      ));
    }
    return boxesForLetters;
  }

  List<Widget> _buildBoxesWithLetters(DictantTrainingEntity word) {
    final List<Widget> boxesForLetters = [];
    for (int index = 0; index < suggestedLetters.length; index++) {
      boxesForLetters.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () async {
            if (correctAnswer[currentLetterIndex] == suggestedLetters[index]) {
              setState(() {
                colors[index] = const Color(0xFF85977f);
                currentLetterIndex++;
              });
              if (currentLetterIndex == correctAnswer.length) {
                updateCurrentWord();
                if (!mistakes.contains(word)) {
                  await pool.play(correctSoundId);
                  correctAnswers.add(word);
                }
              }
            } else {
              if (colors[index] == const Color(0xFF85977f)) {
                return;
              }
              setState(() {
                attempts++;
                colors[index] = const Color(0xFFB70E0E);
              });

              if (attempts == maxAttempts) {
                mistakes.add(word);
                await pool.play(wrongSoundId);
                updateCurrentWord();
              }
            }
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(suggestedLetters[index]),
            ),
          ),
        ),
      ));
    }
    return boxesForLetters;
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
