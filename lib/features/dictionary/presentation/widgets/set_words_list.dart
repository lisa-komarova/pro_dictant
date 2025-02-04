import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:pro_dictant/features/dictionary/presentation/pages/set_words_cards_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/trainings_page.dart';

import '../../../profile/presentation/manager/profile_bloc.dart';
import '../../../profile/presentation/manager/profile_state.dart';
import '../manager/words_bloc/words_bloc.dart';

class SetWordsList extends StatefulWidget {
  const SetWordsList({
    super.key,
  });

  @override
  State<SetWordsList> createState() => _SetWordsListState();
}

class _SetWordsListState extends State<SetWordsList> {
  List<WordEntity> selectedWords = [];
  bool isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    List<TranslationEntity> wordsTranslations = [];
    int learntPercentage = 0;
    SetEntity setEntity = SetEntity(id: '', name: '', isAddedToDictionary: 0);
    return BlocBuilder<SetBloc, SetsState>(builder: (context, state) {
      if (state is SetLoading) {
        return _loadingIndicator();
      } else if (state is SetLoaded) {
        setEntity = state.set;
        if (setEntity.wordsInSet.isNotEmpty) {
          for (int i = 0; i < setEntity.wordsInSet.length; i++) {
            wordsTranslations
                .add(setEntity.wordsInSet[i].translationList.first);
          }
          learntPercentage = computeLearntPercentage(
              setEntity, wordsTranslations, learntPercentage);
        }

        return buildWordsList(state.set.wordsInSet, wordsTranslations,
            setEntity, learntPercentage, context);
      }
      return const SizedBox();
    });
  }

  int computeLearntPercentage(SetEntity setEntity,
      List<TranslationEntity> wordsTranslations, int learntPercentage) {
    int learntCount = 0;
    int learnt100percent;
    learnt100percent = wordsTranslations.length * 6;
    for (int i = 0; i < wordsTranslations.length; i++) {
      learntCount += wordsTranslations[i].isTW;
      learntCount += wordsTranslations[i].isWT;
      learntCount += wordsTranslations[i].isMatching;
      learntCount += wordsTranslations[i].isCards;
      learntCount += wordsTranslations[i].isDictant;
      learntCount += wordsTranslations[i].isRepeated;
    }
    learntPercentage = (learntCount * 100 / learnt100percent).round();
    return learntPercentage;
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
      int learntPercentage,
      BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
              if (state is ProfileLoaded) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: selectedWords.isNotEmpty
                          ? null
                          : () {
                              Navigator.of(context)
                                ..pop()
                                ..pushReplacement(MaterialPageRoute(
                                    builder: (ctx) => TrainingsPage(
                                          goal: state.statistics.goal,
                                          setId: setEntity.id,
                                          setName: setEntity.name,
                                          isTodayCompleted:
                                              state.statistics.isTodayCompleted,
                                        )));
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: selectedWords.isNotEmpty
                              ? const Color(0x6bd9c3ac)
                              : const Color(0xFF85977f),
                        ),
                        height: 50,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FittedBox(
                              child: Text(
                                S.of(context).sendSetToTrainings,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.hachiMaruPop(
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0x6bd9c3ac),
                      ),
                      height: 50,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FittedBox(
                            child: Text(
                              S.of(context).sendSetToTrainings,
                              textAlign: TextAlign.center,
                              style:
                                  GoogleFonts.hachiMaruPop(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FittedBox(
                        child: AutoSizeText(
                          S.of(context).learntPercentage(learntPercentage),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.hachiMaruPop(
                              color: const Color(0xff5e6b5a)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (setEntity.isAddedToDictionary == 1) {
                      if (selectedWords.isNotEmpty) {
                        List<TranslationEntity> selectedTranslations = [];
                        for (int i = 0; i < selectedWords.length; i++) {
                          selectedTranslations
                              .add(selectedWords[i].translationList.first);
                        }
                        BlocProvider.of<WordsBloc>(context).add(
                            RemoveWordsInSetFromDictionary(
                                words: selectedTranslations));
                        setState(() {
                          setEntity.isAddedToDictionary = 0;
                        });
                        BlocProvider.of<SetBloc>(context).add(UpdateSet(
                            set: setEntity,
                            toAdd: const [],
                            toDelete: const []));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(S.of(context).wordsREmeovedFromDictionary),
                          ),
                        );
                        selectedWords.clear();
                      } else {
                        BlocProvider.of<WordsBloc>(context).add(
                            RemoveWordsInSetFromDictionary(
                                words: translations));
                        setState(() {
                          setEntity.isAddedToDictionary = 0;
                        });
                        BlocProvider.of<SetBloc>(context).add(UpdateSet(
                            set: setEntity,
                            toAdd: const [],
                            toDelete: const []));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(S.of(context).wordsREmeovedFromDictionary),
                          ),
                        );
                      }
                    } else {
                      if (selectedWords.isNotEmpty) {
                        List<TranslationEntity> selectedTranslations = [];
                        for (int i = 0; i < selectedWords.length; i++) {
                          selectedTranslations
                              .add(selectedWords[i].translationList.first);
                        }
                        BlocProvider.of<WordsBloc>(context).add(
                            AddWordsFromSetToDictionary(
                                words: selectedTranslations));
                        BlocProvider.of<SetBloc>(context).add(UpdateSet(
                            set: setEntity,
                            toAdd: const [],
                            toDelete: const []));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).wordsAddedToDictionary),
                          ),
                        );
                        selectedWords.clear();
                      } else {
                        BlocProvider.of<WordsBloc>(context).add(
                            AddWordsFromSetToDictionary(words: translations));

                        BlocProvider.of<SetBloc>(context).add(UpdateSet(
                            set: setEntity,
                            toAdd: const [],
                            toDelete: const []));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).wordsAddedToDictionary),
                          ),
                        );
                      }
                      setState(() {
                        setEntity.isAddedToDictionary = 1;
                      });
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
                onTap: selectedWords.isNotEmpty
                    ? null
                    : () {
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
                    color: selectedWords.isNotEmpty
                        ? const Color(0x6bd9c3ac)
                        : const Color(0xFF85977f),
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
                return GestureDetector(
                  onLongPress: () {
                    if (selectedWords.contains(words[index])) {
                      setState(() {
                        selectedWords.remove(words[index]);
                        if (selectedWords.isEmpty) {
                          isSelectionMode = false;
                        }
                      });
                    } else {
                      setState(() {
                        selectedWords.add(words[index]);
                        isSelectionMode = true;
                      });
                    }
                  },
                  onTap: () async {
                    if (isSelectionMode) {
                      if (selectedWords.contains(words[index])) {
                        setState(() {
                          selectedWords.remove(words[index]);
                          if (selectedWords.isEmpty) {
                            isSelectionMode = false;
                          }
                        });
                      } else {
                        setState(() {
                          selectedWords.add(words[index]);
                          isSelectionMode = true;
                        });
                      }
                    } else {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => SetWordsCardsPage(
                                words: words,
                                index: index,
                              )));
                    }
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
                              selected: selectedWords.contains(words[index]),
                              selectedColor: const Color(0xFFFFFFFF),
                              selectedTileColor: const Color(0xFF5E6B5A),
                            ),
                            Image.asset(
                              'assets/icons/divider.png',
                              width: 15,
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
