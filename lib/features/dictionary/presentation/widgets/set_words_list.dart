import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_state.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/words_details_page.dart';

import '../manager/words_bloc/words_bloc.dart';

class SetWordsList extends StatelessWidget {
  const SetWordsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<TranslationEntity> words = [];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFB70E0E),
              ),
              height: 50,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      'Отправить на изучение',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hachiMaruPop(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              BlocProvider.of<WordsBloc>(context)
                  .add(AddWordsFromSetToDictionary(words: words));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('слова добавлены в словарь!'),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFB70E0E),
              ),
              height: 50,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      'Добавить в словарь',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hachiMaruPop(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocBuilder<SetBloc, SetsState>(builder: (context, state) {
          if (state is SetLoading) {
            return _loadingIndicator();
          } else if (state is SetLoaded) {
            for (int i = 0; i < state.set.wordsInSet.length; i++) {
              words.add(state.set.wordsInSet[i].translationList.first);
            }
            return buildWordsList(state.set.wordsInSet);
          }
          return SizedBox();
        }),
      ],
    );
  }
}

Widget _loadingIndicator() {
  return const Expanded(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}

Expanded buildWordsList(List<WordEntity> words) {
  return Expanded(
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: words.length,
        itemBuilder: (context, index) {
          //bool isInDictionary = (words[index].isInDictionary == 1);
          return GestureDetector(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => WordsDetails(word: words[index])));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                            "${words[index].source} - ${words[index].translationList.first.translation}"),
                      ),
                      Image.asset(
                        'assets/icons/divider.png',
                        width: 15,
                        height: 15,
                      ),
                    ],
                  ),
                ),
                /*isInDictionary
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          'assets/icons/add.png',
                          width: 24,
                          height: 24,
                        ),
                      ),*/
              ],
            ),
          );
        }),
  );
}
