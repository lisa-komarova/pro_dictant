import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_state.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/words_details_page.dart';

class WordsList extends StatefulWidget {
  const WordsList({super.key});

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordsBloc, WordsState>(builder: (context, state) {
      //TODO redo this
      if (state is WordsEmpty) {
        return Expanded(
          child: Center(
            child: Text(
              "Пока слов нет ˙◠˙",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (state is WordsLoading) {
        return _loadingIndicator();
      } else if (state is WordsLoaded) {
        return buildWordsList(state.words.reversed.toSet().toList());
      } else if (state is WordsError) {
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

  Expanded buildWordsList(List<WordEntity> words) {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: words.length,
          itemBuilder: (context, index) {
            //bool isInDictionary = (words[index].isInDictionary == 1);
            final isInDictionary = words[index]
                .translationList
                .where((element) => element.isInDictionary == 1)
                .toList()
                .length;
            final translation = isInDictionary > 0
                ? words[index]
                    .translationList
                    .where((element) => element.isInDictionary == 1)
                    .toList()
                    .first
                    .translation
                : words[index].translationList.first.translation;

            return GestureDetector(
              onTap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                final returnedWord = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (ctx) => WordsDetails(word: words[index])));
                // if (returnedWord == null) {
                //   words.removeAt(index);
                //   setState(() {});
                if (words.contains(returnedWord)) {
                  setState(() {});
                }
                // } else if (words.contains(returnedWord)) {
                //   setState(() {});
                // } else {
                //   setState(() {
                //     words.add(returnedWord);
                //   });
                // }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          title:
                              Text("${words[index].source} - ${translation}"),
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
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
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
}
