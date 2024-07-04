import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/words_bloc/words_event.dart';

import '../widgets/word_form.dart';

class WordsDetails extends StatefulWidget {
  final WordEntity word;

  WordsDetails({required this.word, super.key});

  @override
  State<WordsDetails> createState() => _WordsDetailsState();
}

class _WordsDetailsState extends State<WordsDetails> {
  //TODO redo as it's  memory consuming
  final FlutterTts flutterTts = FlutterTts();
  var isPronounceSelected = false;
  Color _color = const Color(0xFF85977f);

  //Color _color = Color(0xFF243120);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        Navigator.of(context).pop(widget.word);
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                return Navigator.of(context).pop();
              },
              icon: Image.asset('assets/icons/cancel.png')),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: Color(0xFFd9c3ac),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: buildWordsProgressImage(widget.word),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _color = Color(0xFF243120);
                                });
                                speak(widget.word.source);
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.word.source,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.word.pos,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.word.transcription,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: Scrollbar(
                                thumbVisibility: true,
                                radius: const Radius.circular(2),
                                child: SingleChildScrollView(
                                  child: Text(widget.word.translations,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, bottom: 8, top: 8),
                                  child: GestureDetector(
                                    onTap: () =>
                                        _showDialog(context, widget.word),
                                    child: Image.asset(
                                      'assets/icons/delete.png',
                                      width: 35,
                                      height: 35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),

            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    _buildAWordButton(
                        title: "На\nизучение", color: Color(0xFFB70E0E)),
                    _buildAWordButton(
                        title: "Уже знаю", color: Color(0xFF85977f)),
                    _buildAWordButton(
                        title: "Изменить", color: Color(0xFFd9c3ac)),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: 300,
            // )
          ],
        ),
      ),
    );
  }

  Widget buildWordsProgressImage(WordEntity word) {
    var learnt = 0;
    if (word.isTW == 1) {
      learnt++;
    }
    if (word.isWT == 1) {
      learnt++;
    }
    if (word.isCards == 1) {
      learnt++;
    }
    if (word.isMatching == 1) {
      learnt++;
    }
    if (word.isDictant == 1) {
      learnt++;
    }
    if (word.isRepeated == 1) {
      learnt++;
    }
    return Image.asset(
      'assets/icons/learnt$learnt.png',
      width: 35,
      height: 35,
    );
  }

  _buildAWordButton({required String title, required Color color}) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (title == "На\nизучение") {
              _showSendToLearningDialog(context, widget.word);
            }
            if (title == "Уже знаю") {
              _showSendToLearntDialog(context, widget.word);
            }
            if (title == "Изменить") {
              _showUpdateDialog(context, widget.word);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            ),
            height: 50,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.hachiMaruPop(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage('en-GB');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
    setState(() {
      _color = Color(0xFF85977f);
    });
  }
}

Future<void> _showDialog(BuildContext context, WordEntity word) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text(
          'Хотите удалить это слово из своего словаря?',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
              foregroundColor: Color(0xFFB70E0E),
            ),
            child: const Text('удалить'),
            onPressed: () {
              word.isInDictionary = 0;
              BlocProvider.of<WordsBloc>(context)
                  .add(DeleteWordFromDictionary(word));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('отмена'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showSendToLearntDialog(BuildContext context, WordEntity word) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text(
          'Хотите переместить это слово в изученные?',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
              foregroundColor: Color(0xFFB70E0E),
            ),
            child: const Text('да'),
            onPressed: () {
              word.isTW = 1;
              word.isWT = 1;
              word.isMatching = 1;
              word.isCards = 1;
              word.isDictant = 1;
              word.isRepeated = 1;
              BlocProvider.of<WordsBloc>(context).add(UpdateWord(word));
              Navigator.of(context).pop();
              Navigator.of(context).pop(word);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('отмена'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showSendToLearningDialog(BuildContext context, WordEntity word) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text(
          'Хотите сбросить прогрес этого слова?',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
              foregroundColor: Color(0xFFB70E0E),
            ),
            child: const Text('да'),
            onPressed: () {
              word.isTW = 0;
              word.isWT = 0;
              word.isMatching = 0;
              word.isCards = 0;
              word.isDictant = 0;
              word.isRepeated = 0;
              BlocProvider.of<WordsBloc>(context).add(UpdateWord(word));
              Navigator.of(context).pop();
              Navigator.of(context).pop(word);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('отмена'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showUpdateDialog(BuildContext context, WordEntity word) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: WordForm(
          word: word,
          isNew: false,
        ),
      );
    },
  );
}
