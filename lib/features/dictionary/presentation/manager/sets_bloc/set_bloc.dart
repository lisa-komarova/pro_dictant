import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/add_set.dart'
    as usecase2;
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_sets.dart'
    as usecase1;
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_translations_for_words_in_set.dart'
    as usecase4;
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_words_for_sets.dart'
    as usecase3;
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';

// BLoC 8.0.0
class SetBloc extends Bloc<SetsEvent, SetsState> {
  final usecase1.FetchSets loadSets;
  final usecase2.AddSet addSet;
  final usecase3.FetchWordsForSets fetchWordsForSets;
  final usecase4.FetchTranslationsForWordsInSet fetchTranslationsForWordsInSet;

  SetBloc({
    required this.loadSets,
    required this.addSet,
    required this.fetchWordsForSets,
    required this.fetchTranslationsForWordsInSet,
  }) : super(SetsLoading()) {
    on<LoadSets>(_onLoadSetsEvent);
    on<AddSet>(_onAddSetEvent);
    on<FetchWordsForSets>(_onFetchWordsForSetsEvent);
    on<FetchTranslationsForWordsInSets>(
        _onFetchTranslationsForWordsInSetsEvent);
  }

  FutureOr<void> _onLoadSetsEvent(
      LoadSets event, Emitter<SetsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(SetsLoading());

    final failureOrSets = await loadSets();

    failureOrSets
        .fold((error) => emit(SetsError(message: _mapFailureToMessage(error))),
            (sets) {
      if (sets.isEmpty) {
        emit(SetsEmpty());
      } else {
        add(FetchWordsForSets(sets: sets));
      }
    });
  }

  FutureOr<void> _onFetchWordsForSetsEvent(
      FetchWordsForSets event, Emitter<SetsState> emit) async {
    emit(SetsLoading());

    final failureOrSets = await fetchWordsForSets(event.sets);

    failureOrSets
        .fold((error) => emit(SetsError(message: _mapFailureToMessage(error))),
            (sets) {
      if (sets.isEmpty) {
        emit(SetsEmpty());
      } else {
        // for(int i = 0; i < sets.length; i++){
        //   add(FetchTranslationsForWordsInSets(set: sets[i]));
        // }
        emit(SetsLoaded(sets: sets));
      }
    });
  }

  FutureOr<void> _onFetchTranslationsForWordsInSetsEvent(
      FetchTranslationsForWordsInSets event, Emitter<SetsState> emit) async {
    emit(SetLoading());
    final failureOrSetCompleted = await fetchTranslationsForWordsInSet(
        event.set.wordsInSet, event.set.id);

    failureOrSetCompleted
        .fold((error) => emit(SetsError(message: _mapFailureToMessage(error))),
            (words) {
      event.set.wordsInSet.clear();
      event.set.wordsInSet.addAll(words);
      emit(SetLoaded(
        set: event.set,
      ));
    });
  }

  FutureOr<void> _onAddSetEvent(AddSet event, Emitter<SetsState> emit) async {
    //TODO check what it's for

    await addSet(event.set);

    emit(SetsLoading());

    final failureOrSets = await loadSets();

    failureOrSets
        .fold((error) => emit(SetsError(message: _mapFailureToMessage(error))),
            (sets) {
      if (sets.isEmpty) {
        emit(SetsEmpty());
      } else {
        add(FetchWordsForSets(sets: sets));
      }
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
