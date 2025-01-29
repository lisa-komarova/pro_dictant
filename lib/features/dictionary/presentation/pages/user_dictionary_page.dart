import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/search_container.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/words_list.dart';
import 'package:uuid/uuid.dart';

import 'word_form_page.dart';

class UserDictionaryPage extends StatefulWidget {
  const UserDictionaryPage({
    super.key,
  });

  @override
  State<UserDictionaryPage> createState() => _UserDictionaryPageState();
}

class _UserDictionaryPageState extends State<UserDictionaryPage> {
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
        title: Text(S.of(context).myDictionary),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset(
              'assets/icons/cancel.png',
              width: 35,
              height: 35,
            )),
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
          WordsList(editingController),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final word = WordModel(
            id: const Uuid().v4(),
            source: editingController.text,
            pos: '',
            transcription: '',
          );
          editingController.text = '';
          BlocProvider.of<WordsBloc>(context).add(const LoadWords());
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => WordForm(word: word, isNew: true)));
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        label: Text(
          S.of(context).newWord,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
