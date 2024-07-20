import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/words_details_page.dart';

class SetWordsList extends StatelessWidget {
  final List<WordEntity> wordInSet;

  const SetWordsList({super.key, required this.wordInSet});

  @override
  Widget build(BuildContext context) {
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
        buildWordsList(wordInSet),
      ],
    );
  }
}

Expanded buildWordsList(List<WordEntity> words) {
  return Expanded(
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: words.length,
        itemBuilder: (context, index) {
          bool isInDictionary = (words[index].isInDictionary == 1);
          return GestureDetector(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final returnedWord = await Navigator.of(context).push(
                  MaterialPageRoute(
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
                            "${words[index].source} - ${words[index].translations}"),
                      ),
                      Image.asset(
                        'assets/icons/divider.png',
                        width: 15,
                        height: 15,
                      ),
                    ],
                  ),
                ),
                isInDictionary
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          'assets/icons/add.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
              ],
            ),
          );
        }),
  );
}
