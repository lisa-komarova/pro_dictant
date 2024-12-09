import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/user_dictionary_page.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/user_set_page.dart';

class DictionaryPage extends StatelessWidget {
  const DictionaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F2ED),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<WordsBloc>(context).add(const LoadWords());
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => UserDictionaryPage()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: const Color(0xFFD9C3AC),
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  S.of(context).myDictionary,
                  textAlign: TextAlign.center,
                  //style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<SetBloc>(context).add(const LoadSets());
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const UserSetPage()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: const Color(0xFFD9C3AC),
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  S.of(context).wordSets,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
