import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';

abstract class WordsState extends Equatable {
  const WordsState();

  @override
  List<Object> get props => [];
}

class WordsEmpty extends WordsState {
  final bool isNew;
  final bool isLearning;
  final bool isLearnt;

  WordsEmpty(
      {required this.isNew, required this.isLearning, required this.isLearnt});
}

class WordsLoading extends WordsState {}

class WordsLoaded extends WordsState {
  final List<WordEntity> words;
  final bool isNew;
  final bool isLearning;
  final bool isLearnt;

  const WordsLoaded(
      {required this.words,
      required this.isNew,
      required this.isLearning,
      required this.isLearnt});

  @override
  List<Object> get props => [words];
}

class WordsError extends WordsState {
  final String message;

  const WordsError({required this.message});

  @override
  List<Object> get props => [message];
}

class SearchedWordsEmpty extends WordsState {}

class SearchedWordsLoading extends WordsState {}

class SearchedWordsLoaded extends WordsState {
  final List<WordEntity> words;

  const SearchedWordsLoaded({required this.words});

  @override
  List<Object> get props => [words];
}

class SearchedWordsError extends WordsState {
  final String message;

  const SearchedWordsError({required this.message});

  @override
  List<Object> get props => [message];
}
