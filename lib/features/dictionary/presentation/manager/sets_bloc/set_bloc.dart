import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/load_sets.dart'
    as usecase1;
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_event.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';

// BLoC 8.0.0
class SetBloc extends Bloc<SetsEvent, SetsState> {
  final usecase1.LoadSets loadSets;

  SetBloc({
    required this.loadSets,
  }) : super(SetsLoading()) {
    on<LoadSets>(_onLoadSetsEvent);
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
        emit(SetsLoaded(
          sets: sets,
        ));
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
