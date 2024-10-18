import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/word_form_page.dart';

class WordTranslationCards extends StatefulWidget {
  final WordEntity word;

  const WordTranslationCards({required this.word, super.key});

  @override
  State<WordTranslationCards> createState() => _WordTranslationCardsState();
}

class _WordTranslationCardsState extends State<WordTranslationCards>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  final _scrollController = ScrollController();
  final FlutterTts flutterTts = FlutterTts();
  var isPronounceSelected = false;
  Color _color = const Color(0xFF85977f);
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    sortTranslationList(widget.word);
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 7,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              PageView(
                /// [PageView.scrollDirection] defaults to [Axis.horizontal].
                /// Use [Axis.vertical] to scroll vertically.
                controller: _pageViewController,
                onPageChanged: _handlePageViewChanged,
                children: <Widget>[
                  for (var element in widget.word.translationList)
                    buildTranslastionCard(_scrollController, context, element),
                ],
              ),
            ],
          ),
        ),
        // buildTranslastionCard (scrollController, context, widget.word.translationList[0]),
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                _buildAWordButton(
                    title: "На\nизучение", color: Color(0xFFB70E0E)),
                _buildAWordButton(title: "Уже знаю", color: Color(0xFF85977f)),
                _buildAWordButton(title: "Изменить", color: Color(0xFFd9c3ac)),
              ],
            ),
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
          onTap: () {
            if (title == "На\nизучение") {
              _showSendToLearningDialog(
                  context, widget.word, _currentPageIndex);
            }
            if (title == "Уже знаю") {
              _showSendToLearntDialog(context, widget.word, _currentPageIndex);
            }
            if (title == "Изменить") {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => WordForm(
                  word: widget.word,
                  isNew: false,
                ),
              ));
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

  Widget buildTranslastionCard(ScrollController scrollController,
      BuildContext context, TranslationEntity translation) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        controller: scrollController,
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
                      child: buildWordsProgressImage(translation),
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
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.word.pos,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 12),
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
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
                    controller: ScrollController(),
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
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (translation.isInDictionary == 1)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () => _showDialog(context, translation, true),
                          child: Image.asset(
                            'assets/icons/delete.png',
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                    if (translation.isInDictionary == 0)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 8, top: 8),
                        child: GestureDetector(
                          onTap: () => _showDialogDelete(context, translation),
                          child: Image.asset(
                            'assets/icons/delete.png',
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                    if (translation.isInDictionary == 0) Spacer(),
                    if (translation.isInDictionary == 0)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 8, top: 8),
                        child: GestureDetector(
                          onTap: () => _showDialog(context, translation, false),
                          child: Image.asset(
                            'assets/icons/add.png',
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
      _color = Color(0xFF85977f);
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
                ? 'Хотите удалить это слово из своего словаря?'
                : 'Хотите добавить это слово в свой словарь?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                foregroundColor: Color(0xFFB70E0E),
              ),
              child: Text(toDelete ? 'удалить' : 'добавить'),
              onPressed: () {
                if (toDelete) {
                  translation.isInDictionary = 0;
                  BlocProvider.of<WordsBloc>(context)
                      .add(UpdateTranslation(translation));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  //TODO resfresh list
                } else {
                  translation.isInDictionary = 1;
                  translation.dateAddedToDictionary = DateTime.now().toString();
                  BlocProvider.of<WordsBloc>(context)
                      .add(UpdateTranslation(translation));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
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

  void sortTranslationList(WordEntity word) {
    List<TranslationEntity> inDictList = [];
    word.translationList.forEach((e) {
      if (e.isInDictionary == 1) inDictList.add(e);
    });
    word.translationList.removeWhere((element) => element.isInDictionary == 1);
    inDictList.forEach((element) {
      word.translationList.insert(0, element);
    });
  }
}

Future<void> _showDialogDelete(
    BuildContext context, TranslationEntity translation) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text(
          'Хотите удалить это слово из словаря навсегда?',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
              foregroundColor: Color(0xFFB70E0E),
            ),
            child: const Text('удалить'),
            onPressed: () {
              BlocProvider.of<WordsBloc>(context)
                  .add(DeleteTranslation(translation));
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

Future<void> _showSendToLearntDialog(
    BuildContext context, WordEntity word, int index) {
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
              word.translationList[index].isInDictionary = 1;
              word.translationList[index].isTW = 1;
              word.translationList[index].isWT = 1;
              word.translationList[index].isMatching = 1;
              word.translationList[index].isCards = 1;
              word.translationList[index].isDictant = 1;
              word.translationList[index].isRepeated = 1;
              BlocProvider.of<WordsBloc>(context)
                  .add(UpdateTranslation(word.translationList[index]));
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

Future<void> _showSendToLearningDialog(
    BuildContext context, WordEntity word, int index) {
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
