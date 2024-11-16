import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';

abstract class WordsEvent extends Equatable {
  const WordsEvent();

  @override
  List<Object> get props => [];
}

class FilterWords extends WordsEvent {
  final String wordQuery;
  final bool isNew;
  final bool isLearning;
  final bool isLearnt;

  const FilterWords(this.wordQuery, this.isNew, this.isLearning, this.isLearnt);
}

class LoadWords extends WordsEvent {
  const LoadWords();
}

class FetchTranslationsForWords extends WordsEvent {
  final List<WordEntity> words;

  const FetchTranslationsForWords(this.words);
}

class FetchTranslationsForSearchedWords extends WordsEvent {
  final List<WordEntity> words;

  const FetchTranslationsForSearchedWords(this.words);
}

class FetchWordBySource extends WordsEvent {
  final String source;

  const FetchWordBySource(this.source);
}

class DeleteWordFromDictionary extends WordsEvent {
  final TranslationEntity translationEntity;

  const DeleteWordFromDictionary(this.translationEntity);
}

class AddWordsFromSetToDictionary extends WordsEvent {
  final List<TranslationEntity> words;

  const AddWordsFromSetToDictionary({required this.words});
}

class RemoveWordsInSetFromDictionary extends WordsEvent {
  final List<TranslationEntity> words;

  const RemoveWordsInSetFromDictionary({required this.words});
}

class UpdateWord extends WordsEvent {
  final WordEntity word;

  const UpdateWord(this.word);
}

class UpdateTranslation extends WordsEvent {
  final TranslationEntity translation;

  const UpdateTranslation(this.translation);
}

class DeleteTranslation extends WordsEvent {
  final TranslationEntity translation;

  const DeleteTranslation(this.translation);
}

class AddTranslation extends WordsEvent {
  final TranslationEntity translation;

  const AddTranslation(this.translation);
}

class AddWord extends WordsEvent {
  final WordEntity word;

  const AddWord(this.word);
}

class DeleteWord extends WordsEvent {
  final WordEntity word;

  const DeleteWord(this.word);
}

class SearchWordsForASet extends WordsEvent {
  final String wordQuery;

  const SearchWordsForASet(this.wordQuery);
}
