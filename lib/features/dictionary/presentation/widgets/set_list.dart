import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetBloc, SetsState>(builder: (context, state) {
      if (state is SetsEmpty) {
        return Center(
          child: Text(
            "Пока наборов слов нет ˙◠˙",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        );
      } else if (state is SetsLoading) {
        return _loadingIndicator();
      } else if (state is SetsLoaded) {
        return buildSetsList(state.sets.reversed.toList());
      } else if (state is SetsError) {
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
          const SizedBox(
            height: 100,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: sets.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: ValueKey(sets[index]),
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
                    BlocProvider.of<SetBloc>(context)
                        .add(DeleteSet(setId: sets[index].id));
                  },
                  child: GestureDetector(
                    onTap: () async {
                      BlocProvider.of<SetBloc>(context).add(
                          FetchTranslationsForWordsInSets(set: sets[index]));
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => SetsWordsPage(set: sets[index])));
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text(
                                  overflow: TextOverflow.fade,
                                  "${sets[index].wordsInSet.length} \n слов",
                                  style: Theme.of(context).textTheme.titleLarge,
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
        ],
      ),
    );
  }

  Future<void> _pullRefresh() async {
    BlocProvider.of<SetBloc>(context).add(const LoadSets());
  }
}
