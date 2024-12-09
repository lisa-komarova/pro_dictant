import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_state.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/new_set_page.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/words_details_page.dart';

import '../manager/words_bloc/words_bloc.dart';

class SetWordsList extends StatefulWidget {
  const SetWordsList({
    super.key,
  });

  @override
  State<SetWordsList> createState() => _SetWordsListState();
}

class _SetWordsListState extends State<SetWordsList> {
  @override
  Widget build(BuildContext context) {
    List<TranslationEntity> wordsTranslations = [];
    SetEntity setEntity = SetEntity(id: '', name: '', isAddedToDictionary: 0);
    return BlocBuilder<SetBloc, SetsState>(builder: (context, state) {
      if (state is SetLoading) {
        return _loadingIndicator();
      } else if (state is SetLoaded) {
        setEntity = state.set;
        for (int i = 0; i < state.set.wordsInSet.length; i++) {
          wordsTranslations.add(state.set.wordsInSet[i].translationList.first);
        }
        return buildWordsList(
            state.set.wordsInSet, wordsTranslations, setEntity, context);
      }
      return const SizedBox();
    });
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Column buildWordsList(
      List<WordEntity> words,
      List<TranslationEntity> translations,
      SetEntity setEntity,
      BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (setEntity.isAddedToDictionary == 0) {
                      BlocProvider.of<WordsBloc>(context).add(
                          AddWordsFromSetToDictionary(words: translations));
                      setState(() {
                        setEntity.isAddedToDictionary = 1;
                      });
                      BlocProvider.of<SetBloc>(context).add(UpdateSet(
                          set: setEntity, toAdd: const [], toDelete: const []));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).wordsAddedToDictionary),
                        ),
                      );
                    } else {
                      BlocProvider.of<WordsBloc>(context).add(
                          RemoveWordsInSetFromDictionary(words: translations));
                      setState(() {
                        setEntity.isAddedToDictionary = 0;
                      });
                      BlocProvider.of<SetBloc>(context).add(UpdateSet(
                          set: setEntity, toAdd: const [], toDelete: const []));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(S.of(context).wordsREmeovedFromDictionary),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: setEntity.isAddedToDictionary == 1
                          ? const Color(0xFFB70E0E)
                          : const Color(0xFF85977f),
                    ),
                    height: 50,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FittedBox(
                          child: Text(
                            setEntity.isAddedToDictionary == 0
                                ? S.of(context).addToDictionary
                                : S.of(context).removeFromDictionary,
                            textAlign: TextAlign.center,
                            style:
                                GoogleFonts.hachiMaruPop(color: Colors.white),
                          ),
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
                  if (setEntity.id.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => NewSetPage(
                              set: setEntity,
                            )));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF85977f),
                  ),
                  height: 50,
                  width: 60,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/icons/dictant.png',
                            width: 35,
                            height: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
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
                        builder: (ctx) => WordsDetails(
                              word: words[index],
                              isFromSet: true,
                            )));
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
        ),
      ],
    );
  }
}
