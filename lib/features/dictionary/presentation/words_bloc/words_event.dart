import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';

abstract class WordsEvent extends Equatable {
  const WordsEvent();

  @override
  List<Object> get props => [];
}

class FilterWords extends WordsEvent {
  final String wordQuery;

  const FilterWords(this.wordQuery);
}

class LoadWords extends WordsEvent {
  const LoadWords();
}

class GetNewWords extends WordsEvent {
  const GetNewWords();
}

class GetLearningWords extends WordsEvent {
  const GetLearningWords();
}

class GetLearntWords extends WordsEvent {
  const GetLearntWords();
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
