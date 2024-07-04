import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/get_learning_words.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/get_learnt_words.dart';
import 'package:pro_dictant/features/dictionary/presentation/words_bloc/words_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/words_bloc/words_state.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/get_all_words_in_dict.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/filter_words.dart'
    as usecase1;
import 'package:pro_dictant/features/dictionary/domain/usecases/delete_word_from_dictionary.dart'
    as usecase2;
import 'package:pro_dictant/features/dictionary/domain/usecases/update_word.dart'
    as usecase3;
import '../../domain/usecases/get_new_words.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/add_word.dart'
    as usecase4;

const SERVER_FAILURE_MESSAGE = 'Server Failure';

// BLoC 8.0.0
class WordsBloc extends Bloc<WordsEvent, WordsState> {
  final GetAllWordsInDict loadWords;
  final GetNewWordsInDict getNewWords;
  final GetLearningWordsInDict getLearningWordsInDict;
  final GetLearntWordsInDict getLearntWordsInDict;
  final usecase1.FilterWords filterWords;
  final usecase2.DeleteWordFromDictionary deleteWordFromDictionary;
  final usecase3.UpdateWord updateWord;
  final usecase4.AddWord addWord;

  WordsBloc(
      {required this.loadWords,
      required this.getNewWords,
      required this.getLearningWordsInDict,
      required this.getLearntWordsInDict,
      required this.filterWords,
      required this.deleteWordFromDictionary,
      required this.updateWord,
      required this.addWord})
      : super(WordsLoading()) {
    on<LoadWords>(_onLoadWordsEvent);
    on<FilterWords>(_onFilterWordsEvent);
    on<DeleteWordFromDictionary>(_onDeleteWordFromDictionaryEvent);
    on<GetNewWords>(_onGetNewWordsEvent);
    on<GetLearningWords>(_onGetLearningWordsEvent);
    on<GetLearntWords>(_onGetLearntWordsEvent);
    on<UpdateWord>(_onUpdateWordEvent);
    on<AddWord>(_onAddWordEvent);
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

  FutureOr<void> _onGetNewWordsEvent(
      GetNewWords event, Emitter<WordsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(WordsLoading());

    final failureOrWord = await getNewWords();

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

  FutureOr<void> _onGetLearningWordsEvent(
      GetLearningWords event, Emitter<WordsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(WordsLoading());

    final failureOrWord = await getLearningWordsInDict();

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

  FutureOr<void> _onGetLearntWordsEvent(
      GetLearntWords event, Emitter<WordsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(WordsLoading());

    final failureOrWord = await getLearntWordsInDict();

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

    final failureOrWord = await filterWords(event.wordQuery);

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

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
