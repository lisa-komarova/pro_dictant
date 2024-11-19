import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/words_details_page.dart';
import 'package:uuid/uuid.dart';

class WordForm extends StatefulWidget {
  final WordEntity word;
  final bool isNew;

  const WordForm({required this.word, super.key, required this.isNew});

  @override
  State<WordForm> createState() => _WordFormState();
}

class _WordFormState extends State<WordForm> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _posController = TextEditingController();
  final _transcriptionController = TextEditingController();
  final List<TextEditingController> _translationControllerList = [];
  final List<TranslationEntity> translations = [];
  final List<TranslationEntity> existingTranslations = [];
  bool isTranslationDeleted = false;
  bool isTranslationAdded = false;

  @override
  void initState() {
    if (widget.isNew == false) {
      _sourceController.text = widget.word.source;
      _posController.text = widget.word.pos;
      //_translationController.text = widget.word.translations;
      _transcriptionController.text = widget.word.transcription;
      for (var w = 0; w < widget.word.translationList.length; w++) {
        _translationControllerList.add(TextEditingController());
        _translationControllerList[w].text =
            widget.word.translationList[w].translation;
        translations.add(widget.word.translationList[w]);
        existingTranslations.add(widget.word.translationList[w]);
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
    _transcriptionController.dispose();
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
                      controller: _transcriptionController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontFamily: 'Roboto'),
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
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (widget.isNew)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _translationControllerList[0],
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
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
                      buildTranslationTextFields(),
                    ]),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      translations.add(TranslationEntity(
                          id: const Uuid().v4(),
                          wordId: widget.word.id,
                          translation: '',
                          notes: ''));
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
                        color: const Color(0xFF85977f).withOpacity(0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
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
                          foregroundColor: const Color(0xFFB70E0E),
                        ),
                        child: widget.isNew
                            ? const Text('добавить')
                            : const Text('обновить'),
                        onPressed: () {
                          Set<TranslationEntity> toDelete = {};
                          Set<TranslationEntity> toUpdate = {};
                          Set<TranslationEntity> toAdd = {};
                          if (_formKey.currentState!.validate()) {
                            widget.word.source = _sourceController.text;
                            widget.word.pos = _posController.text;
                            widget.word.transcription =
                                _transcriptionController.text;
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
                              for (var i = 0;
                                  i < _translationControllerList.length;
                                  i++) {
                                translations[i].translation =
                                    _translationControllerList[i].text;
                              }
                              final newTranslationsIds =
                                  translations.map((e) => e.id).toList();
                              final oldTranslationsIds = existingTranslations
                                  .map((e) => e.id)
                                  .toList();
                              for (int i = 0;
                                  i < existingTranslations.length;
                                  i++) {
                                if (newTranslationsIds
                                        .contains(existingTranslations[i].id) &&
                                    oldTranslationsIds
                                        .contains(existingTranslations[i].id)) {
                                  toUpdate.add(existingTranslations[i]);
                                }
                                if (!newTranslationsIds
                                    .contains(existingTranslations[i].id)) {
                                  toDelete.add(existingTranslations[i]);
                                }
                              }
                              for (int i = 0; i < translations.length; i++) {
                                if (!oldTranslationsIds
                                    .contains(translations[i].id)) {
                                  TranslationEntity newTranslation =
                                      TranslationEntity(
                                    id: const Uuid().v4(),
                                    wordId: widget.word.id,
                                    translation: translations[i].translation,
                                    notes: '',
                                  );
                                  if (translations[i].isInDictionary == 1) {
                                    newTranslation.isInDictionary = 1;
                                    newTranslation.dateAddedToDictionary =
                                        translations[i].dateAddedToDictionary;
                                  }
                                  toAdd.add(newTranslation);
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
                              if (toUpdate.isNotEmpty) {
                                for (int i = 0; i < toUpdate.length; i++) {
                                  BlocProvider.of<WordsBloc>(context).add(
                                      UpdateTranslation(toUpdate.elementAt(i)));
                                }
                              }
                              if (toDelete.isNotEmpty) {
                                for (int i = 0; i < toDelete.length; i++) {
                                  BlocProvider.of<WordsBloc>(context).add(
                                      DeleteTranslation(toDelete.elementAt(i)));
                                }
                              }
                              if (toAdd.isNotEmpty) {
                                for (int i = 0; i < toAdd.length; i++) {
                                  BlocProvider.of<WordsBloc>(context)
                                      .add(AddTranslation(toAdd.elementAt(i)));
                                }
                              }
                              widget.word.translationList.clear();
                              widget.word.translationList.addAll(translations);
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (ctx) => WordsDetails(
                                            word: widget.word,
                                            isFromSet: false,
                                          )));
                            }
                          }
                        },
                      ),
                    ),
                    const Spacer(),
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

  buildTranslationTextFields() {
    return Flexible(
      child: ListView.builder(
          itemCount: translations.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _translationControllerList[index],
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
                if (index >= 1)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        translations.removeAt(index);
                      });
                      _translationControllerList[index].dispose();
                      _translationControllerList.removeAt(index);
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
            );
          }),
    );
  }
}
