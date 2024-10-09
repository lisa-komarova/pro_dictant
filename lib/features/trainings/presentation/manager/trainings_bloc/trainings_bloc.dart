import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/use_cases/add_suggested_sources_to_words_in_tw.dart'
    as usecase4;
import 'package:pro_dictant/features/trainings/domain/use_cases/add_suggested_translations_to_words_in_wt.dart'
    as usecase2;
import 'package:pro_dictant/features/trainings/domain/use_cases/fetch_words_for_matching_training.dart'
    as usecase7;
import 'package:pro_dictant/features/trainings/domain/use_cases/fetch_words_for_tw_training.dart'
    as usecase5;
import 'package:pro_dictant/features/trainings/domain/use_cases/fetch_words_for_wt_training.dart'
    as usecase1;
import 'package:pro_dictant/features/trainings/domain/use_cases/update_words_for_matching_training.dart'
    as usecase8;
import 'package:pro_dictant/features/trainings/domain/use_cases/update_words_for_tw_trainings.dart'
    as usecase6;
import 'package:pro_dictant/features/trainings/domain/use_cases/update_words_for_wt_trainings.dart'
    as usecase3;
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';

// BLoC 8.0.0
class TrainingsBloc extends Bloc<TrainingsEvent, TrainingsState> {
  final usecase1.FetchWordsForWTTraining loadWords;
  final usecase2.AddSuggestedTranslationsToWordsInWT
      addSuggestedTranslationsToWordsInWT;
  final usecase3.UpdateWordsForWTTraining updateWordsForWTTraining;
  final usecase4.AddSuggestedSourcesToWordsInTW addSuggestedSourcesToWordsInTW;
  final usecase5.FetchWordsForTWTraining fetchWordsForTwTRainings;
  final usecase6.UpdateWordsForTWTraining updateWordsForTWTraining;
  final usecase7.FetchWordsForMatchingTraining fetchWordsForMatchingTRaining;
  final usecase8.UpdateWordsForMatchingTraining updateWordsForMatchingTraining;

  TrainingsBloc({
    required this.loadWords,
    required this.addSuggestedTranslationsToWordsInWT,
    required this.updateWordsForWTTraining,
    required this.fetchWordsForTwTRainings,
    required this.addSuggestedSourcesToWordsInTW,
    required this.updateWordsForTWTraining,
    required this.fetchWordsForMatchingTRaining,
    required this.updateWordsForMatchingTraining,
  }) : super(TrainingLoading()) {
    on<FetchWordsForWtTRainings>(_onFetchWordsForWtTRainingsEvent);
    on<FetchWordsForTwTRainings>(_onFetchWordsForTwTRainingsEvent);
    on<FetchWordsForMatchingTRainings>(_onFetchWordsForMatchingTRainingsEvent);
    on<AddSuggestedTranslationsToWordsInWT>(
        _onAddSuggestedTranslationsToWordsInWTEvent);
    on<AddSuggestedSourcesToWordsInTW>(_onAddSuggestedSourcesToWordsInTWEvent);
    on<UpdateWordsForWtTRainings>(_onUpdateWordsForWtTRainingsEvent);
    on<UpdateWordsForTwTRainings>(_onUpdateWordsForTwTRainingsEvent);
    on<UpdateWordsForMatchingTRainings>(
        _onUpdateWordsForMatchingTRainingsEvent);
  }

  FutureOr<void> _onFetchWordsForWtTRainingsEvent(
      FetchWordsForWtTRainings event, Emitter<TrainingsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(TrainingLoading());

    final failureOrWords = await loadWords();

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        add(AddSuggestedTranslationsToWordsInWT(words));
      }
    });
  }

  FutureOr<void> _onFetchWordsForMatchingTRainingsEvent(
      FetchWordsForMatchingTRainings event,
      Emitter<TrainingsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(TrainingLoading());

    final failureOrWords = await fetchWordsForMatchingTRaining();

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty || words.length < 5) {
        emit(TrainingEmpty());
      } else {
        emit(MatchingTrainingLoaded(words: words));
      }
    });
  }

  FutureOr<void> _onFetchWordsForTwTRainingsEvent(
      FetchWordsForTwTRainings event, Emitter<TrainingsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(TrainingLoading());

    final failureOrWords = await fetchWordsForTwTRainings();

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        add(AddSuggestedSourcesToWordsInTW(words));
      }
    });
  }

  FutureOr<void> _onUpdateWordsForWtTRainingsEvent(
      UpdateWordsForWtTRainings event, Emitter<TrainingsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;
    await updateWordsForWTTraining(event.toUpdate);
  }

  FutureOr<void> _onUpdateWordsForTwTRainingsEvent(
      UpdateWordsForTwTRainings event, Emitter<TrainingsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;
    await updateWordsForTWTraining(event.toUpdate);
  }

  FutureOr<void> _onUpdateWordsForMatchingTRainingsEvent(
      UpdateWordsForMatchingTRainings event,
      Emitter<TrainingsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;
    await updateWordsForMatchingTraining(event.toUpdate);
  }

  FutureOr<void> _onAddSuggestedTranslationsToWordsInWTEvent(
      AddSuggestedTranslationsToWordsInWT event,
      Emitter<TrainingsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(TrainingLoading());

    final failureOrWords =
        await addSuggestedTranslationsToWordsInWT(event.words);

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        emit(WTTrainingLoaded(
          words: words,
        ));
      }
    });
  }

  FutureOr<void> _onAddSuggestedSourcesToWordsInTWEvent(
      AddSuggestedSourcesToWordsInTW event,
      Emitter<TrainingsState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(TrainingLoading());

    final failureOrWords = await addSuggestedSourcesToWordsInTW(event.words);

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        emit(TWTrainingLoaded(
          words: words,
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
