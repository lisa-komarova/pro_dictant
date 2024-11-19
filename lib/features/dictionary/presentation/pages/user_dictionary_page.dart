import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/dictionary_filter_buttons.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/search_container.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/words_list.dart';
import 'package:uuid/uuid.dart';

import 'word_form_page.dart';

class UserDictionaryPage extends StatefulWidget {
  const UserDictionaryPage({super.key});

  @override
  State<UserDictionaryPage> createState() => _UserDictionaryPageState();
}

class _UserDictionaryPageState extends State<UserDictionaryPage> {
  TextEditingController editingController = TextEditingController();
  bool isSearching = false;

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
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset('assets/icons/cancel.png')),
      ),
      body: Column(
        children: [
          SearchContainer(
            controller: editingController,
            searchHandler: (String searchText) {
              if (searchText.length >= 2) {
                BlocProvider.of<WordsBloc>(context)
                    .add(FilterWords(searchText, false, false, false));
              } else if (searchText.isEmpty) {
                BlocProvider.of<WordsBloc>(context).add(const LoadWords());
              }
            },
          ),
          const DictionaryFilterButtons(),
          WordsList(editingController),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final word = WordModel(
            id: const Uuid().v4(),
            source: '',
            pos: '',
            transcription: '',
          );
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => WordForm(word: word, isNew: true)));
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
}
