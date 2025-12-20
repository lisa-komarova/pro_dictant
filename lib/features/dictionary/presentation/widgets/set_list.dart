import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_state.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/sets_words_page.dart';

class SetList extends StatefulWidget {
  const SetList({super.key});

  @override
  State<SetList> createState() => _SetListState();
}

class _SetListState extends State<SetList> {
  List<SetEntity> sets = [];
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetBloc, SetsState>(builder: (context, state) {
      if (state is SetsEmpty) {
        return Center(
          child: Text(
            S.of(context).noWordsYet,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        );
      } else if (state is SetsLoading) {
        return _loadingIndicator();
      } else if (state is SetsLoaded) {
        if (sets.isNotEmpty) sets.clear();
        sets.addAll(state.sets.reversed.toList());
        return buildSetsList(sets);
      } else if (state is SetsError) {
        return Text(
          state.message,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        );
      } else {
        return buildSetsList(sets);
      }
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

  Widget buildSetsList(List<SetEntity> sets) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                interactive: true,
                radius: Radius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: sets.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        key: UniqueKey(),
                        background: Row(
                          children: [
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/icons/delete.png',
                                width: 35,
                                height: 35,
                                color: const Color(0xFFB70E0E),
                              ),
                            ),
                          ],
                        ),
                        onDismissed: (DismissDirection direction) {
                          _showShouldDeleteSetDialog(
                              context, sets, sets[index], index);
                        },
                        child: GestureDetector(
                          onTap: () async {
                            BlocProvider.of<SetBloc>(context).add(
                                FetchTranslationsForWordsInSets(
                                    set: sets[index]));
                            SetEntity? setToReplace =
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            const SetsWordsPage()));
                            if (setToReplace != null) {
                              setState(() {
                                sets[index] = setToReplace;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                height: 100,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: const Color(0xFFD9C3AC),
                                  ),
                                  color: const Color(0xFFFFFFFF),
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          overflow: TextOverflow.fade,
                                          sets[index].name.toUpperCase(),
                                          locale: const Locale('en', 'GB'),
                                      style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        overflow: TextOverflow.fade,
                                        "${sets[index].wordsInSet.length} \n " + S.of(context).words(sets[index].wordsInSet.length),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pullRefresh() async {
    BlocProvider.of<SetBloc>(context).add(const LoadSets());
  }

  Future<void> _showShouldDeleteSetDialog(
      BuildContext context, List<SetEntity> sets, SetEntity set, int index) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(S.of(context).shouldDeleteSet),
          actions: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  foregroundColor: const Color(0xFFB70E0E),
                ),
                child: Text(S.of(context).yes),
                onPressed: () {
                  BlocProvider.of<SetBloc>(context)
                      .add(DeleteSet(setId: set.id));
                  Navigator.of(context).pop();
                }),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(S.of(context).cancel),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
