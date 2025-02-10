import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_state.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/user_set_page.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/words_details_page.dart';

import '../manager/sets_bloc/set_bloc.dart';
import '../manager/sets_bloc/set_event.dart';
import 'dictionary_filter_buttons.dart';

class WordsList extends StatefulWidget {
  final TextEditingController editingController;

  const WordsList(this.editingController, {super.key});

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordsBloc, WordsState>(builder: (context, state) {
      if (state is WordsEmpty) {
        return Flexible(
          child: Column(
            children: [
              DictionaryFilterButtons(
                isNewSelected: state.isNew,
                isLearningSelected: state.isLearning,
                isLearntSelected: state.isLearnt,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.editingController.text.isEmpty
                        ? Text(
                            S.of(context).noWordYet,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            S.of(context).noSuchWords,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!state.isNew &&
                        !state.isLearning &&
                        !state.isLearnt &&
                        widget.editingController.text.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                            onPressed: () {
                              BlocProvider.of<SetBloc>(context)
                                  .add(const LoadSets());
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (ctx) => const UserSetPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFd9c3ac),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                S.of(context).addWordsFromDictioanry,
                                textAlign: TextAlign.center,
                              ),
                            )),
                      )
                  ],
                ),
              ),
            ],
          ),
        );
      } else if (state is WordsLoading) {
        return Flexible(
          child: Column(
            children: [
              const DictionaryFilterButtons(
                isNewSelected: false,
                isLearningSelected: false,
                isLearntSelected: false,
              ),
              _loadingIndicator(),
            ],
          ),
        );
      } else if (state is WordsLoaded) {
        return Flexible(
          child: Column(
            children: [
              DictionaryFilterButtons(
                isNewSelected: state.isNew,
                isLearningSelected: state.isLearning,
                isLearntSelected: state.isLearnt,
              ),
              buildWordsList(
                state.words,
                state.isNew,
                state.isLearning,
                state.isLearnt,
              ),
            ],
          ),
        );
      } else if (state is WordsError) {
        return Text(
          state.message,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        );
      } else {
        return const SizedBox();
      }
    });
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

  Expanded buildWordsList(
    List<WordEntity> wordsToBuild,
    bool isNew,
    bool isLearning,
    bool isLearnt,
  ) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _refreshList,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: wordsToBuild.length,
            itemBuilder: (context, index) {
              var translation = '';
              final isInDictionary = wordsToBuild[index]
                  .translationList
                  .where((element) => element.isInDictionary == 1)
                  .toList()
                  .length;
              if (wordsToBuild[index].translationList.isNotEmpty) {
                translation = isInDictionary > 0
                    ? wordsToBuild[index]
                        .translationList
                        .where((element) => element.isInDictionary == 1)
                        .toList()
                        .first
                        .translation
                    : wordsToBuild[index].translationList.first.translation;
              }
              return GestureDetector(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  final result =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => WordsDetails(
                                word: wordsToBuild[index],
                              )));
                  if (result != null && result == 'delete') {
                    widget.editingController.text = '';
                  } else if (result != null) {
                    if (result is WordEntity) {
                      setState(() {
                        wordsToBuild[index] = result;
                        widget.editingController.text = '';
                      });
                    } else if (result is Map) {
                      if (result.values.first == 'sendToLearnt' && isNew) {
                        setState(() {
                          wordsToBuild[index] = result.keys.first;
                          wordsToBuild.remove(result.keys.first);
                        });
                      }
                      if (result.values.first == 'sendToLearnt' && isLearning) {
                        setState(() {
                          wordsToBuild[index] = result.keys.first;
                          wordsToBuild.remove(result.keys.first);
                        });
                      }
                      if (result.values.first == 'sendToLearnt' && isLearnt) {
                        setState(() {
                          wordsToBuild[index] = result.keys.first;
                        });
                      }
                      if (result.values.first == 'sendToLearning' && isNew) {
                        setState(() {
                          wordsToBuild[index] = result.keys.first;
                          wordsToBuild.remove(result.keys.first);
                        });
                      }
                      if (result.values.first == 'sendToLearning' &&
                          isLearning) {
                        setState(() {
                          wordsToBuild[index] = result.keys.first;
                        });
                      }
                      if (result.values.first == 'sendToLearning' && isLearnt) {
                        setState(() {
                          wordsToBuild[index] = result.keys.first;
                          wordsToBuild.remove(result.keys.first);
                        });
                      }
                    }
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
                                "${wordsToBuild[index].source} - $translation"),
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
    );
  }

  Future<void> _refreshList() async {
    setState(() {
      widget.editingController.text = '';
    });
    BlocProvider.of<WordsBloc>(context).add(const LoadWords());
  }
}
