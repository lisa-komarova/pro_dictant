import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/add_word.dart'
    as usecase4;
import 'package:pro_dictant/features/dictionary/domain/usecases/delete_word_from_dictionary.dart'
    as usecase2;
import 'package:pro_dictant/features/dictionary/domain/usecases/filter_words.dart'
    as usecase1;
import 'package:pro_dictant/features/dictionary/domain/usecases/load_all_words_in_dict.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/searchWordsForASet.dart'
    as usecase5;
import 'package:pro_dictant/features/dictionary/domain/usecases/update_word.dart'
    as usecase3;
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_state.dart';

import '../../../domain/usecases/fetch_word_by_source.dart' as usecase5;

const SERVER_FAILURE_MESSAGE = 'Server Failure';

// BLoC 8.0.0
class WordsBloc extends Bloc<WordsEvent, WordsState> {
  final LoadAllWordsInDict loadWords;
  final usecase5.FetchWordBySource fetchWordBySource;
  final usecase1.FilterWords filterWords;
  final usecase2.DeleteWordFromDictionary deleteWordFromDictionary;
  final usecase3.UpdateWord updateWord;
  final usecase4.AddWord addWord;
  final usecase5.SearchWordsForASet searchWordsForASet;

  WordsBloc({
    required this.loadWords,
    required this.fetchWordBySource,
    required this.filterWords,
    required this.deleteWordFromDictionary,
    required this.updateWord,
    required this.addWord,
    required this.searchWordsForASet,
  }) : super(WordsLoading()) {
    on<LoadWords>(_onLoadWordsEvent);
    on<FilterWords>(_onFilterWordsEvent);
    on<DeleteWordFromDictionary>(_onDeleteWordFromDictionaryEvent);
    on<UpdateWord>(_onUpdateWordEvent);
    on<AddWord>(_onAddWordEvent);
    on<FetchWordBySource>(_onFetchWordBySourceEvent);
    on<SearchWordsForASet>(_onSearchWordsForASetEvent);
  }

  FutureOr<void> _onLoadWordsEvent(
      LoadWords event, Emitter<WordsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(WordsLoading());

    final failureOrWord = await loadWords();

    failureOrWord
        .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
            (words) {
      if (words.isEmpty) {
        emit(WordsEmpty());
      } else {
        emit(WordsLoaded(
          words: words,
        ));
      }
    });
  }

  FutureOr<void> _onFilterWordsEvent(
      FilterWords event, Emitter<WordsState> emit) async {
    emit(WordsLoading());

    final failureOrWord = await filterWords(
        event.wordQuery, event.isNew, event.isLearning, event.isLearnt);
//TODO: smth shady here
    failureOrWord
        .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
            (words) async {
      if (words.isEmpty) {
        emit(WordsEmpty());
        //TODO what's that for
        add(FetchWordBySource(event.wordQuery));
      } else {
        emit(WordsLoaded(
          words: words,
        ));
      }
    });
  }

  FutureOr<void> _onSearchWordsForASetEvent(
      SearchWordsForASet event, Emitter<WordsState> emit) async {
    emit(SearchedWordsLoading());

    final failureOrWord = await searchWordsForASet(event.wordQuery);
//TODO: smth shady here
    failureOrWord.fold(
        (error) =>
            emit(SearchedWordsError(message: _mapFailureToMessage(error))),
        (words) async {
      if (words.isEmpty) {
        emit(SearchedWordsEmpty());
        //add(FetchWordBySource(event.wordQuery));
      } else {
        emit(SearchedWordsLoaded(
          words: words,
        ));
      }
    });
  }

  FutureOr<void> _onFetchWordBySourceEvent(
      FetchWordBySource event, Emitter<WordsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(WordsLoading());

    final failureOrWord = await fetchWordBySource(event.source);

    failureOrWord
        .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
            (words) {
      if (words.isEmpty) {
        emit(WordsEmpty());
      } else {
        emit(WordsLoaded(
          words: words,
        ));
      }
    });
  }

  FutureOr<void> _onDeleteWordFromDictionaryEvent(
      DeleteWordFromDictionary event, Emitter<WordsState> emit) async {
    await deleteWordFromDictionary(event.word);
    emit(WordsLoading());

    final failureOrWord = await loadWords();

    failureOrWord
        .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
            (words) {
      emit(WordsLoaded(
        words: words,
      ));
    });
  }

  FutureOr<void> _onUpdateWordEvent(
      UpdateWord event, Emitter<WordsState> emit) async {
    await updateWord(event.word);
    // emit(WordsLoading());
    //
    // final failureOrWord = await loadWords();
    //
    // failureOrWord
    //     .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
    //         (words) {
    //   emit(WordsLoaded(
    //     words: words,
    //   ));
    // });
  }

  FutureOr<void> _onAddWordEvent(
      AddWord event, Emitter<WordsState> emit) async {
    await addWord(event.word);

    emit(WordsLoading());

    final failureOrWord = await loadWords();

    failureOrWord
        .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
            (words) {
      emit(WordsLoaded(
        words: words,
      ));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
