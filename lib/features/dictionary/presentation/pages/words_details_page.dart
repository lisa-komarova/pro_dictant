import 'package:flutter/material.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/words_translation_cards.dart';

class WordsDetails extends StatefulWidget {
  final WordEntity word;
  const WordsDetails({required this.word, super.key});

  @override
  State<WordsDetails> createState() => _WordsDetailsState();
}

class _WordsDetailsState extends State<WordsDetails> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPope, _) {
        if (!didPope) {
          Navigator.of(context).pop(widget.word);
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  return Navigator.of(context).pop(widget.word);
                },
                icon: Image.asset('assets/icons/cancel.png')),
          ),
          body: WordTranslationCards(
            word: widget.word,
          ),
        ),
      ),
    );
  }
}
