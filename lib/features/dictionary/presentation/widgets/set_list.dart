import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';
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
        return Expanded(
          child: Center(
            child: Text(
              "Пока наборов слов нет ˙◠˙",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
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
      } else
        return SizedBox();
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

  Expanded buildSetsList(List<SetEntity> sets) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: sets.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
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
                        color: Color(0xFFFFFFFF),
                      ),
                      child: Center(
                        child: Text(
                          overflow: TextOverflow.fade,
                          "${sets[index].name.toUpperCase()}  ",
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                      )
                      // Column(
                      //   children: [
                      //
                      //     // ListTile(
                      //     //   title: Text("${sets[index].name} "),
                      //     // ),
                      //   ],
                      // ),
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
