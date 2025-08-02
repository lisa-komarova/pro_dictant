import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/user_set_page.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/search_container.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/words_list.dart';
import 'package:uuid/uuid.dart';

import '../manager/sets_bloc/set_bloc.dart';
import '../manager/sets_bloc/set_event.dart';
import 'word_form_page.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({
    super.key,
  });

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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      BlocProvider.of<SetBloc>(context).add(const LoadSets());
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const UserSetPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffd9c3ac),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        S.of(context).wordSets,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                )),
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
      ),
    );
  }
}
