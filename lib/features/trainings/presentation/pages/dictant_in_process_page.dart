import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/dictant_result_page.dart';

import '../../domain/entities/dictant_training_entity.dart';
import '../manager/trainings_bloc/trainings_bloc.dart';
import '../manager/trainings_bloc/trainings_event.dart';
import '../manager/trainings_bloc/trainings_state.dart';

class DictantInProcessPage extends StatefulWidget {
  const DictantInProcessPage({super.key});

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
  List<DictantTrainingEntity> correctAnswers = [];
  List<DictantTrainingEntity> mistakes = [];
  List<String> suggestedLetters = [];
  Color focusBorderColor = Color(0xff5e6b5a);
  final wordController = TextEditingController();

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
            return Expanded(
              child: Center(
                child: Text(
                  "Пока недостаточно слов для тренировки ˙◠˙",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (state is TrainingLoading) {
            return _loadingIndicator();
          } else if (state is DictantTrainingLoaded) {
            return _buildWordCard(state.words);
          } else
            return SizedBox();
        },
      ),
      floatingActionButton: !isHintSelected
          ? FloatingActionButton(
              onPressed: () {
                wordController.text = '';
                setState(() {
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
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(25),
              ),
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
        // Flexible(
        //   flex: 1,
        //   child: SizedBox(
        //     height: 100,
        //   ),
        // ),
        Flexible(
          flex: 3,
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
                      ? SizedBox(
                          height: 80,
                          child: TextFormField(
                            controller: wordController,
                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontFamily: 'Roboto'),
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
                        )
                      : _buildWordBricks(words[currentWordIndex]),
                  !isHintSelected
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              if (wordController.text.replaceAll(' ', '') ==
                                  words[currentWordIndex]
                                      .source
                                      .replaceAll(' ', '')) {
                                if (!mistakes
                                    .contains(words[currentWordIndex])) {
                                  correctAnswers.add(words[currentWordIndex]);
                                  focusBorderColor = Color(0xFF85977f);
                                }
                                wordController.text = '';
                                updateCurrentWord();
                              } else {
                                if (!mistakes
                                    .contains(words[currentWordIndex])) {
                                  setState(() {
                                    mistakes.add(words[currentWordIndex]);
                                    focusBorderColor = Color(0xFFB70E0E);
                                  });
                                } else {
                                  wordController.text = '';
                                  updateCurrentWord();
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFF85977f),
                              ),
                              height: 50,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: FittedBox(
                                    child: Text(
                                      'Проверить',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.hachiMaruPop(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
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
    if (currentWordIndex == 9) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => DictantResultPage(
                correctAnswers: correctAnswers,
                mistakes: mistakes,
              )));
      BlocProvider.of<TrainingsBloc>(context)
          .add(UpdateWordsForDictantTRainings(correctAnswers));
      return;
    }
    setState(() {
      currentWordIndex++;
      focusBorderColor = Color(0xFF85977f);
      isHintSelected = false;
      correctAnswer = '';
      suggestedLetters = [];
      currentLetterIndex = 0;
      attempts = 0;
      colors = [];
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
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // number of items in each row
                      mainAxisSpacing: 8.0, // spacing between rows
                      crossAxisSpacing: 8.0, // spacing between columns
                    ),
                    itemCount: suggestedLetters.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color(0xFFd9c3ac),
                            ),
                          ),
                          child: Center(
                            child: currentLetterIndex > index
                                ? Text(correctAnswer[index])
                                : Text(''),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // number of items in each row
                      mainAxisSpacing: 8.0, // spacing between rows
                      crossAxisSpacing: 8.0, // spacing between columns
                    ),
                    itemCount: suggestedLetters.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (correctAnswer[currentLetterIndex] ==
                                suggestedLetters[index]) {
                              setState(() {
                                colors[index] = Color(0xFF85977f);
                                currentLetterIndex++;
                              });
                              if (currentLetterIndex == word.source.length) {
                                updateCurrentWord();
                                if (!mistakes.contains(word)) {
                                  correctAnswers.add(word);
                                }
                              }
                            } else {
                              setState(() {
                                attempts++;
                                colors[index] = Color(0xFFB70E0E);
                              });

                              if (attempts == maxAttempts) {
                                mistakes.add(word);
                                updateCurrentWord();
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors[index],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(suggestedLetters[index]),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fillLetters(DictantTrainingEntity word) {
    List<String> searchKeywords = List<String>.generate(
        word.source.length, (index) => word.source[index]);
    searchKeywords.forEach((element) {
      colors.add(Color(0xFFd9c3ac));
    });
    searchKeywords.shuffle();
    correctAnswer = word.source;
    suggestedLetters.addAll(searchKeywords);
  }
}
