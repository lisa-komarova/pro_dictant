import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/dictionary_filter_buttons.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/words_list.dart';
import 'package:pro_dictant/features/dictionary/presentation/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/search_container.dart';
import 'package:pro_dictant/features/dictionary/presentation/words_bloc/words_event.dart';

import 'package:uuid/uuid.dart';

import '../widgets/word_form.dart';

class DictionaryPage extends StatefulWidget {
  DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Мой словарь",
          style: GoogleFonts.hachiMaruPop(),
        ),
        centerTitle: true,
        //leading: IconButton(
        //    onPressed: () {} , icon: Image.asset('assets/icons/cancel.png')),
      ),
      body: Column(
        children: [
          SearchContainer(
            controller: editingController,
            searchHandler: (String searchText) {
              BlocProvider.of<WordsBloc>(context).add(FilterWords(searchText));
              //_searchWords(searchText);
            },
          ),
          DictionaryFilterButtons(),
          const WordsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showNewDialog(context);
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        label: const Text(
          'новое\nслово',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Future<void> _showNewDialog(BuildContext context) {
    //TODO add mapper and replace wordmodel
    final word = WordModel(
        id: const Uuid().v4(),
        source: '',
        pos: '',
        transcription: '',
        translations: '');
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: WordForm(
            word: word,
            isNew: true,
          ),
        );
      },
    );
  }
}
