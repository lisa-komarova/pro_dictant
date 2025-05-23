import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/add_translation.dart'
    as usecase9;
import 'package:pro_dictant/features/dictionary/domain/usecases/add_word.dart'
    as usecase4;
import 'package:pro_dictant/features/dictionary/domain/usecases/delete_translation.dart'
    as usecase8;
import 'package:pro_dictant/features/dictionary/domain/usecases/delete_word_from_dictionary.dart'
    as usecase2;
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_all_words_in_dict.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_translations_for_searched_words_in_set.dart'
    as usecase10;
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_translations_for_words.dart'
    as usecase7;
import 'package:pro_dictant/features/dictionary/domain/usecases/filter_words.dart'
    as usecase1;
import 'package:pro_dictant/features/dictionary/domain/usecases/search_words_for_a_set.dart'
    as usecase5;
import 'package:pro_dictant/features/dictionary/domain/usecases/update_translation.dart'
    as usecase6;
import 'package:pro_dictant/features/dictionary/domain/usecases/update_word.dart'
    as usecase3;
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_state.dart';

import '../../../domain/usecases/add_words_in_set_to_dictionary.dart'
    as usecase11;
import '../../../domain/usecases/delete_word.dart' as usecase12;
import '../../../domain/usecases/fetch_word_by_source.dart' as usecase5;
import '../../../domain/usecases/remove_words_in_set_from_dictionary.dart'
    as usecase13;
import '../../../domain/usecases/search_translation_online.dart' as usecase14;

const serverFailureMessage = 'Server Failure';

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  final FetchAllWordsInDict loadWords;
  final usecase5.FetchWordBySource fetchWordBySource;
  final usecase1.FilterWords filterWords;
  final usecase2.DeleteWordFromDictionary deleteWordFromDictionary;
  final usecase3.UpdateWord updateWord;
  final usecase4.AddWord addWord;
  final usecase5.SearchWordsForASet searchWordsForASet;
  final usecase6.UpdateTranslation updateTranslation;
  final usecase7.FetchTranslationsForWords fetchTranslationsForWords;
  final usecase10.FetchTranslationsForSearchedWordsInSet
      fetchTranslationsForSearchedWordsInSet;
  final usecase8.DeleteTranslation deleteTranslation;
  final usecase9.AddTranslation addTranslation;
  final usecase11.AddWordsInSetToDictionary addWordsFromSetToDictionary;
  final usecase12.DeleteWord deleteWord;
  final usecase13.RemoveWordsInSetFromDictionary removeWordsInSetFromDictionary;
  final usecase14.SearchTranslationOnline searchTranslationOnline;

  WordsBloc({
    required this.loadWords,
    required this.fetchWordBySource,
    required this.filterWords,
    required this.deleteWordFromDictionary,
    required this.updateWord,
    required this.addWord,
    required this.searchWordsForASet,
    required this.updateTranslation,
    required this.fetchTranslationsForWords,
    required this.fetchTranslationsForSearchedWordsInSet,
    required this.deleteTranslation,
    required this.addTranslation,
    required this.addWordsFromSetToDictionary,
    required this.deleteWord,
    required this.removeWordsInSetFromDictionary,
    required this.searchTranslationOnline,
  }) : super(WordsLoading()) {
    on<LoadWords>(_onLoadWordsEvent, transformer: restartable());
    on<FilterWords>(_onFilterWordsEvent, transformer: restartable());
    on<DeleteWordFromDictionary>(_onDeleteWordFromDictionaryEvent);
    on<UpdateWord>(_onUpdateWordEvent);
    on<UpdateTranslation>(_onUpdateTranslationEvent);
    on<AddWord>(_onAddWordEvent);
    on<FetchWordBySource>(_onFetchWordBySourceEvent);
    on<SearchWordsForASet>(_onSearchWordsForASetEvent);
    on<FetchTranslationsForWords>(_onFetchTranslationsForWordsEvent,
        transformer: restartable());
    on<FetchTranslationsForSearchedWords>(
        _onFetchTranslationsForSearchedWordsEvent,
        transformer: restartable());
    on<DeleteTranslation>(_onDeleteTranslationEvent);
    on<AddTranslation>(_onAddTranslationEvent);
    on<AddWordsFromSetToDictionary>(_onAddWordsFromSetToDictionaryEvent);
    on<DeleteWord>(_onDeleteWordEvent);
    on<RemoveWordsInSetFromDictionary>(_onRemoveWordsInSetFromDictionaryEvent);
    on<SearchTranslationOnline>(_onSearchTranslationOnlineEvent);
  }

  FutureOr<void> _onLoadWordsEvent(
      LoadWords event, Emitter<WordsState> emit) async {
    emit(WordsLoading());

    final failureOrWord = await loadWords();

    failureOrWord
        .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
            (words) {
      if (words.isEmpty) {
        emit(WordsEmpty(
          isNew: false,
          isLearning: false,
          isLearnt: false,
        ));
      } else {
        add(FetchTranslationsForWords(words, false, false, false, false));
        // emit(
        //   WordsLoaded(
        //       words: words, isNew: false, isLearning: false, isLearnt: false),
        // );
      }
    });
  }

  FutureOr<void> _onFetchTranslationsForWordsEvent(
      FetchTranslationsForWords event, Emitter<WordsState> emit) async {
    emit(WordsLoading());

    final failureOrWord =
        await fetchTranslationsForWords(event.words, event.shouldSort);

    failureOrWord
        .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
            (words) {
      if (words.isEmpty) {
        emit(WordsEmpty(
          isNew: event.isNew,
          isLearning: event.isLearning,
          isLearnt: event.isLearnt,
        ));
      } else {
        emit(WordsLoaded(
          words: words,
          isNew: event.isNew,
          isLearning: event.isLearning,
          isLearnt: event.isLearnt,
        ));
      }
    });
  }

  FutureOr<void> _onFetchTranslationsForSearchedWordsEvent(
      FetchTranslationsForSearchedWords event, Emitter<WordsState> emit) async {
    emit(SearchedWordsLoading());

    final failureOrWord =
        await fetchTranslationsForSearchedWordsInSet(event.words);

    failureOrWord.fold(
        (error) =>
            emit(SearchedWordsError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(SearchedWordsEmpty());
      } else {
        emit(SearchedWordsLoaded(
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

    failureOrWord
        .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
            (words) async {
      if (words.isEmpty) {
        emit(WordsEmpty(
          isNew: event.isNew,
          isLearning: event.isLearning,
          isLearnt: event.isLearnt,
        ));
      } else {
        if (event.isNew || event.isLearning || event.isLearnt) {
          add(FetchTranslationsForWords(
              words, event.isNew, event.isLearning, event.isLearnt, false));
        } else {
          add(FetchTranslationsForWords(
              words, event.isNew, event.isLearning, event.isLearnt, true));
        }
      }
    });
  }

  FutureOr<void> _onSearchTranslationOnlineEvent(
      SearchTranslationOnline event, Emitter<WordsState> emit) async {
    emit(WordsLoading());

    final failureOrWord = await searchTranslationOnline(event.wordQuery);

    failureOrWord
        .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
            (words) async {
      if (words.isEmpty) {
        emit(WordsEmpty(
          isNew: false,
          isLearning: false,
          isLearnt: false,
        ));
      } else {
        emit(SearchedWordsLoadedRemotely(
          words: words,
        ));
      }
    });
  }

  FutureOr<void> _onSearchWordsForASetEvent(
      SearchWordsForASet event, Emitter<WordsState> emit) async {
    emit(SearchedWordsLoading());

    final failureOrWord = await searchWordsForASet(event.wordQuery);

    failureOrWord.fold(
        (error) =>
            emit(SearchedWordsError(message: _mapFailureToMessage(error))),
        (words) async {
      if (words.isEmpty) {
        emit(SearchedWordsEmpty());
      } else {
        add(FetchTranslationsForSearchedWords(words));
      }
    });
  }

  FutureOr<void> _onFetchWordBySourceEvent(
      FetchWordBySource event, Emitter<WordsState> emit) async {
    emit(WordsLoading());

    final failureOrWord = await fetchWordBySource(event.source);

    failureOrWord
        .fold((error) => emit(WordsError(message: _mapFailureToMessage(error))),
            (words) {
      if (words.isEmpty) {
        emit(WordsEmpty(
          isNew: false,
          isLearning: false,
          isLearnt: false,
        ));
      } else {
        emit(WordsLoaded(
          words: words,
          isNew: false,
          isLearning: false,
          isLearnt: false,
        ));
      }
    });
  }

  FutureOr<void> _onDeleteWordFromDictionaryEvent(
      DeleteWordFromDictionary event, Emitter<WordsState> emit) async {
    await deleteWordFromDictionary(event.translationEntity);
    add(const LoadWords());
  }

  FutureOr<void> _onDeleteWordEvent(
      DeleteWord event, Emitter<WordsState> emit) async {
    await deleteWord(event.word);
    add(const LoadWords());
  }

  FutureOr<void> _onUpdateWordEvent(
      UpdateWord event, Emitter<WordsState> emit) async {
    await updateWord(event.word);
  }

  FutureOr<void> _onUpdateTranslationEvent(
      UpdateTranslation event, Emitter<WordsState> emit) async {
    await updateTranslation(event.translation);
    //add(const LoadWords());
  }

  FutureOr<void> _onAddWordEvent(
      AddWord event, Emitter<WordsState> emit) async {
    await addWord(event.word);
    add(const LoadWords());
  }

  FutureOr<void> _onAddTranslationEvent(
      AddTranslation event, Emitter<WordsState> emit) async {
    await addTranslation(event.translation);
  }

  FutureOr<void> _onDeleteTranslationEvent(
      DeleteTranslation event, Emitter<WordsState> emit) async {
    await deleteTranslation(event.translation);
  }

  FutureOr<void> _onAddWordsFromSetToDictionaryEvent(
      AddWordsFromSetToDictionary event, Emitter<WordsState> emit) async {
    await addWordsFromSetToDictionary(event.words);
  }

  FutureOr<void> _onRemoveWordsInSetFromDictionaryEvent(
      RemoveWordsInSetFromDictionary event, Emitter<WordsState> emit) async {
    await removeWordsInSetFromDictionary(event.words);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
