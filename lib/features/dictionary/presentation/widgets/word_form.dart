import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';

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
  final _translationController = TextEditingController();

  @override
  void dispose() {
    _sourceController.dispose();
    _posController.dispose();
    _transciptionController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isNew == false) {
      _sourceController.text = widget.word.source;
      _posController.text = widget.word.pos;
      _translationController.text = widget.word.translations;
      _transciptionController.text = widget.word.transcription;
    }
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: SizedBox(
          height: 400,
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
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите транскрипцию';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _translationController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 45.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Color(0xFFd9c3ac),
                          width: 3,
                        )),
                    hintText: 'Введите перевод',
                    hintStyle: TextStyle(fontSize: 11),
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
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      foregroundColor: Color(0xFFB70E0E),
                    ),
                    child: widget.isNew
                        ? const Text('добавить')
                        : const Text('обновить'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.word.source = _sourceController.text;
                        widget.word.pos = _posController.text;
                        widget.word.transcription =
                            _transciptionController.text;
                        widget.word.translations = _translationController.text;
                        widget.word.isInDictionary = 1;
                        if (widget.isNew) {
                          BlocProvider.of<WordsBloc>(context)
                              .add(AddWord(widget.word));
                          Navigator.of(context).pop(widget.word);
                        } else {
                          BlocProvider.of<WordsBloc>(context)
                              .add(UpdateWord(widget.word));

                          Navigator.of(context).pop();
                        }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
