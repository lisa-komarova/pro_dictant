import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/user_dictionary_page.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/user_set_page.dart';

class DictionaryPage extends StatelessWidget {
  const DictionaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7F2ED),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => UserDictionaryPage()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Color(0xFFD9C3AC),
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  'мой словарь',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<SetBloc>(context).add(LoadSets());
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => UserSetPage()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Color(0xFFD9C3AC),
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  'наборы слов',
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
