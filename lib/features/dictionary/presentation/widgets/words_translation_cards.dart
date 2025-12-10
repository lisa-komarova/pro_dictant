import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/word_form_page.dart';

import '../../../profile/presentation/manager/profile_bloc.dart';
import '../../../profile/presentation/manager/profile_event.dart';

class WordTranslationCards extends StatefulWidget {
  final WordEntity word;

  const WordTranslationCards({required this.word, super.key});

  @override
  State<WordTranslationCards> createState() => _WordTranslationCardsState();
}

class _WordTranslationCardsState extends State<WordTranslationCards>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  final FlutterTts flutterTts = FlutterTts();
  var isPronounceSelected = false;
  Color _color = const Color(0xFF85977f);
  int _currentPageIndex = 0;
  late WordEntity word;

  @override
  void initState() {
    super.initState();
    word = widget.word;
    sortTranslationList(word);
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              PageView(
                controller: _pageViewController,
                onPageChanged: _handlePageViewChanged,
                children: <Widget>[
                  for (var element in word.translationList)
                    buildTranslastionCard(context, element),
                ],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              _buildAWordButton(
                  title: S.of(context).learn, color: const Color(0xFFB70E0E)),
              _buildAWordButton(
                  title: S.of(context).alreadyKnow,
                  color: const Color(0xFF85977f)),
              _buildAWordButton(
                  title: S.of(context).changeWord,
                  color: const Color(0xFFd9c3ac)),
            ],
          ),
        ),
        // SizedBox(
        //   height: 300,
        // )
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  _buildAWordButton({required String title, required Color color}) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            if (title == S.of(context).learn) {
              _showSendToLearningDialog(context, word, _currentPageIndex);
            }
            if (title == S.of(context).alreadyKnow) {
              _showSendToLearntDialog(context, word, _currentPageIndex);
            }
            if (title == S.of(context).changeWord) {
              WordEntity? wordToReplace =
                  await Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => WordForm(
                  word: word,
                  isNew: false,
                ),
              ));
              if (wordToReplace != null) {
                setState(() {
                  word = wordToReplace;
                });
              }
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

  Widget buildTranslastionCard(
      BuildContext context, TranslationEntity translation) {
    final ScrollController localScrollController = ScrollController();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        controller: localScrollController,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2,
              color: const Color(0xFFd9c3ac),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildWordsProgressImage(translation),
                  ),
                ],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _color = const Color(0xFF243120);
                          });
                          speak(word.source);
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
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: Scrollbar(
                                radius: const Radius.circular(2),
                                child: SingleChildScrollView(
                                  child: Text(word.source,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                ),
                              ),
                            ),
                          ),
                          word.pos.isNotEmpty
                              ? Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      word.pos,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          word.transcription.isNotEmpty
                              ? Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ExcludeSemantics(
                                      child: Text(
                                        word.transcription,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Scrollbar(
                          controller: localScrollController,
                          thumbVisibility: true,
                          radius: const Radius.circular(2),
                          child: SingleChildScrollView(
                            child: Text(translation.translation,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                        ),
                      ),
                    ),
                    translation.notes.isNotEmpty
                        ? Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Scrollbar(
                                radius: const Radius.circular(2),
                                child: SingleChildScrollView(
                                  child: Text(
                                    translation.notes,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (translation.isInDictionary == 1)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () => _showDialog(context, translation, true),
                        child: Semantics(
                          label: S.of(context).deleteWordFromDictionaryButton,
                          child: Image.asset(
                            'assets/icons/delete.png',
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                    ),
                  if (translation.isInDictionary == 0)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 8, top: 8),
                      child: GestureDetector(
                        onTap: () =>
                            _showDialogDelete(context, translation, word),
                        child: Semantics(
                          label: S.of(context).deleteWordFromDBButton,
                          child: Image.asset(
                            'assets/icons/delete.png',
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                    ),
                  if (translation.isInDictionary == 0) const Spacer(),
                  if (translation.isInDictionary == 0)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 8, top: 8),
                      child: GestureDetector(
                        onTap: () => _showDialog(context, translation, false),
                        child: Semantics(
                          label: S.of(context).addWordToDictionaryButton,
                          child: Image.asset(
                            'assets/icons/add.png',
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWordsProgressImage(TranslationEntity translation) {
    var learnt = 0;
    if (translation.isTW == 1) {
      learnt++;
    }
    if (translation.isWT == 1) {
      learnt++;
    }
    if (translation.isCards == 1) {
      learnt++;
    }
    if (translation.isMatching == 1) {
      learnt++;
    }
    if (translation.isDictant == 1) {
      learnt++;
    }
    if (translation.isRepeated == 1) {
      learnt++;
    }
    return Semantics(
      label: S.of(context).progress(learnt),
      child: Image.asset(
        'assets/icons/learnt$learnt.png',
        width: 35,
        height: 35,
      ),
    );
  }

  void sortTranslationList(WordEntity word) {
    List<TranslationEntity> inDictList = [];
    for (var e in word.translationList) {
      if (e.isInDictionary == 1) inDictList.add(e);
    }
    word.translationList.removeWhere((element) => element.isInDictionary == 1);
    for (var element in inDictList) {
      word.translationList.insert(0, element);
    }
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage('en-GB');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
    setState(() {
      _color = const Color(0xFF85977f);
    });
  }

  Future<void> _showDialog(
      BuildContext context, TranslationEntity translation, bool toDelete) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            toDelete
                ? S.of(context).removeWordFromDict
                : S.of(context).addWordToDict,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                foregroundColor: toDelete ? const Color(0xFFB70E0E) : null,
              ),
              child: Text(
                  toDelete ? S.of(context).removeWord : S.of(context).addWord),
              onPressed: () {
                if (toDelete) {
                  BlocProvider.of<WordsBloc>(context)
                      .add(DeleteWordFromDictionary(translation));
                  BlocProvider.of<ProfileBloc>(context)
                      .add(const LoadStatistics());
                  Navigator.of(context).pop();
                  Navigator.of(context).pop('delete');
                } else {
                  translation.isInDictionary = 1;
                  translation.dateAddedToDictionary = DateTime.now().toString();
                  BlocProvider.of<WordsBloc>(context)
                      .add(UpdateTranslation(translation));
                  BlocProvider.of<WordsBloc>(context).add(LoadWords());
                  Navigator.of(context).pop();
                  Navigator.of(context).pop('added');
                }
                BlocProvider.of<ProfileBloc>(context)
                    .add(const LoadStatistics());
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                foregroundColor: toDelete ? null : const Color(0xFFB70E0E),
              ),
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDialogDelete(
      BuildContext context, TranslationEntity translation, WordEntity word) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            S.of(context).removeWordPermanently,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                foregroundColor: const Color(0xFFB70E0E),
              ),
              child: Text(S.of(context).removeWord),
              onPressed: () {
                if (word.translationList.length == 1) {
                  BlocProvider.of<WordsBloc>(context).add(DeleteWord(word));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop('delete');
                } else {
                  word.translationList.remove(translation);
                  BlocProvider.of<WordsBloc>(context)
                      .add(DeleteTranslation(translation));
                  Navigator.of(context).pop();
                  //Navigator.of(context).pop(word);
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSendToLearntDialog(
      BuildContext context, WordEntity word, int index) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            S.of(context).markAsLearnt,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(S.of(context).yes),
              onPressed: () {
                word.translationList[index].isInDictionary = 1;
                if (word.translationList[index].dateAddedToDictionary == "") {
                  word.translationList[index].dateAddedToDictionary =
                      DateTime.now().toString();
                }
                word.translationList[index].isTW = 1;
                word.translationList[index].isWT = 1;
                word.translationList[index].isMatching = 1;
                word.translationList[index].isCards = 1;
                word.translationList[index].isDictant = 1;
                word.translationList[index].isRepeated = 1;
                BlocProvider.of<WordsBloc>(context)
                    .add(UpdateTranslation(word.translationList[index]));
                Navigator.of(context).pop();
                Navigator.of(context).pop({word: 'sendToLearnt'});
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                foregroundColor: const Color(0xFFB70E0E),
              ),
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSendToLearningDialog(
      BuildContext context, WordEntity word, int index) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            S.of(context).markAsNew,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(S.of(context).yes),
              onPressed: () {
                word.translationList[index].isInDictionary = 1;
                word.translationList[index].isTW = 0;
                word.translationList[index].isWT = 0;
                word.translationList[index].isMatching = 0;
                word.translationList[index].isCards = 0;
                word.translationList[index].isDictant = 0;
                word.translationList[index].isRepeated = 0;
                if (word.translationList[index].dateAddedToDictionary == "") {
                  word.translationList[index].dateAddedToDictionary =
                      DateTime.now().toString();
                }
                BlocProvider.of<WordsBloc>(context)
                    .add(UpdateTranslation(word.translationList[index]));
                Navigator.of(context).pop();
                Navigator.of(context).pop({word: 'sendToLearning'});
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                foregroundColor: const Color(0xFFB70E0E),
              ),
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
