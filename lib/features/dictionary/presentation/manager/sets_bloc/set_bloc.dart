import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/add_set.dart'
    as usecase2;
import 'package:pro_dictant/features/dictionary/domain/usecases/delete_set.dart'
    as usecase5;
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_sets.dart'
    as usecase1;
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_set_with_words.dart'
    as usecase4;
import 'package:pro_dictant/features/dictionary/domain/usecases/update_set.dart'
    as usecase6;
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_state.dart';

const serverFailureMessage = 'Server Failure';

class SetBloc extends Bloc<SetsEvent, SetsState> {
  final usecase1.FetchSets loadSets;
  final usecase2.AddSet addSet;
  final usecase4.FetchSetWithWords fetchSetWithWords;
  final usecase5.DeleteSet deleteSet;
  final usecase6.UpdateSet updateSet;

  SetBloc({
    required this.loadSets,
    required this.addSet,
    required this.fetchSetWithWords,
    required this.deleteSet,
    required this.updateSet,
  }) : super(SetsLoading()) {
    on<LoadSets>(_onLoadSetsEvent);
    on<AddSet>(_onAddSetEvent);
    on<FetchSetWithWords>(
        _onFetchSetWithWordsEvent);
    on<DeleteSet>(_onDeleteSetEvent);
    on<UpdateSet>(_onUpdateSetEvent);
  }

  FutureOr<void> _onLoadSetsEvent(
      LoadSets event, Emitter<SetsState> emit) async {
    emit(SetsLoading());

    final failureOrSets = await loadSets();

    failureOrSets
        .fold((error) => emit(SetsError(message: _mapFailureToMessage(error))),
            (sets) {
      if (sets.isEmpty) {
        emit(SetsEmpty());
      } else {
        emit(SetsLoaded(sets: sets));
      }
    });
  }

  FutureOr<void> _onFetchSetWithWordsEvent(
      FetchSetWithWords event, Emitter<SetsState> emit) async {
    emit(SetLoading());
    final failureOrSetCompleted = await fetchSetWithWords(
        event.setId);

      failureOrSetCompleted
        .fold((error) => emit(SetsError(message: _mapFailureToMessage(error))),
            (set) {
              emit(SetLoaded(
                set: set,
              ));
    });

  }

  FutureOr<void> _onAddSetEvent(AddSet event, Emitter<SetsState> emit) async {
    emit(SetsLoading());
    await addSet(event.set);
    add(const LoadSets());
  }

  FutureOr<void> _onUpdateSetEvent(
      UpdateSet event, Emitter<SetsState> emit) async {
    emit(SetLoading());
    await updateSet(event.set, event.toAdd, event.toDelete);
    emit(SetLoaded(set: event.set));
  }

  FutureOr<void> _onDeleteSetEvent(
      DeleteSet event, Emitter<SetsState> emit) async {
    await deleteSet(event.setId);
    add(const LoadSets());
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
