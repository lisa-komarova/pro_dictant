import 'package:equatable/equatable.dart';
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

class FetchWordBySource extends WordsEvent {
  final String source;

  const FetchWordBySource(this.source);
}

class DeleteWordFromDictionary extends WordsEvent {
  final WordEntity word;

  const DeleteWordFromDictionary(this.word);
}

class UpdateWord extends WordsEvent {
  final WordEntity word;

  const UpdateWord(this.word);
}

class AddWord extends WordsEvent {
  final WordEntity word;

  const AddWord(this.word);
}
