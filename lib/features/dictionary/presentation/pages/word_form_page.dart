import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:uuid/uuid.dart';

class WordForm extends StatefulWidget {
  final WordEntity word;
  final bool isNew;

  WordForm({required this.word, super.key, required this.isNew});

  @override
  State<WordForm> createState() => _WordFormState();
}

class _WordFormState extends State<WordForm> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _posController = TextEditingController();
  final _transciptionController = TextEditingController();
  final List<TextEditingController> _translationControllerList = [];
  int numberOfTranslations = 1;
  bool isTranslationDeleted = false;
  bool isTranslationAdded = false;

  @override
  void initState() {
    if (widget.isNew == false) {
      _sourceController.text = widget.word.source;
      _posController.text = widget.word.pos;
      //_translationController.text = widget.word.translations;
      _transciptionController.text = widget.word.transcription;
      numberOfTranslations = widget.word.translationList.length;
      for (var w = 0; w < widget.word.translationList.length; w++) {
        _translationControllerList.add(TextEditingController());
        _translationControllerList[w].text =
            widget.word.translationList[w].translation;
      }
    } else {
      _translationControllerList.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _posController.dispose();
    _transciptionController.dispose();
    for (var a in _translationControllerList) {
      a.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset('assets/icons/cancel.png')),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: _sourceController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: Color(0xFFd9c3ac),
                              width: 3,
                            )),
                        hintText: 'Введите слово',
                        hintStyle: TextStyle(fontSize: 11),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите слово';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: _posController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: Color(0xFFd9c3ac),
                              width: 3,
                            )),
                        hintText: 'Введите часть речи',
                        hintStyle: TextStyle(fontSize: 11),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите часть речи';
                        }
                        return null;
                        // The validator receives the text that the user has entered.
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: _transciptionController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontFamily: 'Roboto'),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: Color(0xFFd9c3ac),
                              width: 3,
                            )),
                        hintText: 'Введите транскрипцию',
                        hintStyle: GoogleFonts.hachiMaruPop(fontSize: 11),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: buildTranslationTextFields(),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      numberOfTranslations++;
                      _translationControllerList.add(TextEditingController());
                      isTranslationAdded = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF85977f).withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/icons/add.png',
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                          foregroundColor: Color(0xFFB70E0E),
                        ),
                        child: widget.isNew
                            ? const Text('добавить')
                            : const Text('обновить'),
                        onPressed: () {
                          Set<TranslationEntity> toDelete = {};
                          Set<String> toAdd = {};
                          if (_formKey.currentState!.validate()) {
                            widget.word.source = _sourceController.text;
                            widget.word.pos = _posController.text;
                            if (_transciptionController.text == null) {
                              widget.word.transcription = '';
                            } else {
                              widget.word.transcription =
                                  _transciptionController.text;
                            }
                            var existingTranslations = [];
                            if (widget.isNew) {
                              widget.word.translationList
                                  .addAll(_translationControllerList.map((e) {
                                TranslationEntity newTranslation =
                                    TranslationEntity(
                                  id: const Uuid().v4(),
                                  wordId: widget.word.id,
                                  translation: e.text,
                                  notes: '',
                                );
                                if (_translationControllerList.indexOf(e) ==
                                    0) {
                                  newTranslation.isInDictionary = 1;
                                  newTranslation.dateAddedToDictionary =
                                      DateTime.now().toString();
                                }
                                return newTranslation;
                              }).toList());
                            } else {
                              existingTranslations = widget.word.translationList
                                  .map((e) => e.translation)
                                  .toList();
                              for (var i = 0;
                                  i < _translationControllerList.length;
                                  i++) {
                                // if (widget.isNew) {
                                //   widget.word.translationList[i].translation =
                                //       _translationControllerList[i].text;
                                // } else {
                                if (isTranslationDeleted) {
                                  widget.word.translationList
                                      .forEach((element) {
                                    if (element.translation !=
                                        _translationControllerList[i].text) {
                                      toDelete.add(element);
                                    }
                                  });
                                  widget.word.translationList.removeWhere(
                                      (element) => toDelete.contains(element));
                                }
                                if (isTranslationAdded) {
                                  if (!existingTranslations.contains(
                                      _translationControllerList[i].text)) {
                                    toAdd.add(
                                        _translationControllerList[i].text);
                                  }
                                } else if (!isTranslationDeleted &&
                                    !isTranslationAdded) {
                                  widget.word.translationList[i].translation =
                                      _translationControllerList[i].text;
                                }
                              }
                            }
                          }

                          if (widget.isNew) {
                            BlocProvider.of<WordsBloc>(context)
                                .add(AddWord(widget.word));
                            Navigator.of(context).pop(widget.word);
                          } else {
                            BlocProvider.of<WordsBloc>(context)
                                .add(UpdateWord(widget.word));
                            widget.word.translationList.forEach((element) {
                              BlocProvider.of<WordsBloc>(context)
                                  .add(UpdateTranslation(element));
                            });
                            if (toDelete.length > 0) {
                              for (int i = 0; i < toDelete.length; i++) {
                                BlocProvider.of<WordsBloc>(context).add(
                                    DeleteWordFromDictionary(
                                        toDelete.elementAt(i)));
                              }
                            }
                            if (toAdd.length > 0) {
                              for (int i = 0; i < toAdd.length; i++) {
                                TranslationEntity newTranslation =
                                    TranslationEntity(
                                  id: const Uuid().v4(),
                                  wordId: widget.word.id,
                                  translation: toAdd.elementAt(i),
                                  notes: '',
                                );
                                newTranslation.isInDictionary = 1;
                                newTranslation.dateAddedToDictionary =
                                    DateTime.now().toString();
                                BlocProvider.of<WordsBloc>(context)
                                    .add(AddTranslation(newTranslation));
                              }
                            }
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('отмена'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildTranslationTextFields() {
    List<Widget> list = [];
    for (var i = 0; i < numberOfTranslations; i++) {
      list.add(Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _translationControllerList[i],
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(
                        color: Color(0xFFd9c3ac),
                        width: 3,
                      )),
                  hintText: 'Введите перевод',
                  hintStyle: TextStyle(fontSize: 10),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите перевод';
                  }
                  return null;
                },
              ),
            ),
          ),
          if (i >= 1)
            GestureDetector(
              onTap: () {
                setState(() {
                  numberOfTranslations--;
                });
                _translationControllerList[i].dispose();
                _translationControllerList.removeAt(i);
                isTranslationDeleted = true;
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/icons/delete.png',
                  width: 35,
                  height: 35,
                ),
              ),
            ),
        ],
      ));
    }
    return list;
  }
}
