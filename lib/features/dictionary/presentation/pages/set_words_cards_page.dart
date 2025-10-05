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

import '../../../profile/presentation/manager/profile_bloc.dart';
import '../../../profile/presentation/manager/profile_event.dart';

class SetWordsCardsPage extends StatefulWidget {
  final List<WordEntity> words;
  final int index;

  const SetWordsCardsPage(
      {required this.words, super.key, required this.index});

  @override
  State<SetWordsCardsPage> createState() => _SetWordsCardsPageState();
}

class _SetWordsCardsPageState extends State<SetWordsCardsPage>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  final FlutterTts flutterTts = FlutterTts();
  var isPronounceSelected = false;
  Color _color = const Color(0xFF85977f);
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.index;
    _pageViewController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) {
          Navigator.of(context).pop('update');
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  return Navigator.of(context).pop('update');
                },
                icon: Image.asset('assets/icons/cancel.png')),
          ),
          body: Column(
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
                        for (var element in widget.words)
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
                        title: S.of(context).learn,
                        color: const Color(0xFFB70E0E)),
                    _buildAWordButton(
                        title: S.of(context).alreadyKnow,
                        color: const Color(0xFF85977f)),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 300,
              // )
            ],
          ),
        ),
      ),
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
          onTap: () {
            if (title == S.of(context).learn) {
              _showSendToLearningDialog(
                  context, widget.words[_currentPageIndex]);
            }
            if (title == S.of(context).alreadyKnow) {
              _showSendToLearntDialog(context, widget.words[_currentPageIndex]);
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

  Widget buildTranslastionCard(BuildContext context, WordEntity word) {
    final ScrollController scrollControllerSource = ScrollController();
    final ScrollController scrollControllerTranslation = ScrollController();
    final ScrollController scrollControllerNotes = ScrollController();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
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
                    child: buildWordsProgressImage(word.translationList.first),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: Scrollbar(
                                controller: scrollControllerSource,
                                thumbVisibility: true,
                                radius: const Radius.circular(2),
                                child: SingleChildScrollView(
                                  controller: scrollControllerSource,
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
                                    padding: const EdgeInsets.all(5.0),
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
                          controller: scrollControllerTranslation,
                          thumbVisibility: true,
                          radius: const Radius.circular(2),
                          child: SingleChildScrollView(
                            controller: scrollControllerTranslation,
                            child: Text(word.translationList.first.translation,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                        ),
                      ),
                    ),
                    word.translationList.first.notes.isNotEmpty
                        ? Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Scrollbar(
                                controller: scrollControllerNotes,
                                thumbVisibility: true,
                                radius: const Radius.circular(2),
                                child: SingleChildScrollView(
                                  controller: scrollControllerNotes,
                                  child: Text(
                                    word.translationList.first.notes,
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
                  if (word.translationList.first.isInDictionary == 1)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () => _showDialog(
                            context, word.translationList.first, true),
                        child: Image.asset(
                          'assets/icons/delete.png',
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                  if (word.translationList.first.isInDictionary == 0)
                    const Spacer(),
                  if (word.translationList.first.isInDictionary == 0)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 8, top: 8),
                      child: GestureDetector(
                        onTap: () => _showDialog(
                            context, word.translationList.first, false),
                        child: Image.asset(
                          'assets/icons/add.png',
                          width: 35,
                          height: 35,
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
    return Image.asset(
      'assets/icons/learnt$learnt.png',
      width: 35,
      height: 35,
    );
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
                  setState(() {
                    BlocProvider.of<WordsBloc>(context)
                        .add(DeleteWordFromDictionary(translation));
                    Navigator.of(context).pop();
                  });
                } else {
                  setState(() {
                    translation.isInDictionary = 1;
                    translation.dateAddedToDictionary =
                        DateTime.now().toString();
                    BlocProvider.of<WordsBloc>(context)
                        .add(UpdateTranslation(translation));
                    Navigator.of(context).pop();
                  });
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

  Future<void> _showSendToLearntDialog(
    BuildContext context,
    WordEntity word,
  ) {
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
                setState(() {
                  word.translationList[0].isInDictionary = 1;
                  word.translationList[0].isTW = 1;
                  word.translationList[0].isWT = 1;
                  word.translationList[0].isMatching = 1;
                  word.translationList[0].isCards = 1;
                  word.translationList[0].isDictant = 1;
                  word.translationList[0].isRepeated = 1;
                  BlocProvider.of<WordsBloc>(context)
                      .add(UpdateTranslation(word.translationList[0]));
                  Navigator.of(context).pop();
                });
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
      BuildContext context, WordEntity word) {
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
                setState(() {
                  word.translationList[0].isInDictionary = 1;
                  word.translationList[0].isTW = 0;
                  word.translationList[0].isWT = 0;
                  word.translationList[0].isMatching = 0;
                  word.translationList[0].isCards = 0;
                  word.translationList[0].isDictant = 0;
                  word.translationList[0].isRepeated = 0;
                  if (word.translationList[0].dateAddedToDictionary == "") {
                    word.translationList[0].dateAddedToDictionary =
                        DateTime.now().toString();
                  }
                  BlocProvider.of<WordsBloc>(context)
                      .add(UpdateTranslation(word.translationList[0]));
                  Navigator.of(context).pop();
                });
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
