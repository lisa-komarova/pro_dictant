import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/use_cases/add_suggested_sources_to_words_in_tw.dart'
    as usecase4;
import 'package:pro_dictant/features/trainings/domain/use_cases/add_suggested_translations_to_words_in_wt.dart'
    as usecase2;
import 'package:pro_dictant/features/trainings/domain/use_cases/fetch_set_words_for_tw_training.dart';
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

import '../../../domain/use_cases/fetch_set_words_for_cards_training.dart';
import '../../../domain/use_cases/fetch_set_words_for_dictant_training.dart';
import '../../../domain/use_cases/fetch_set_words_for_matching_training.dart';
import '../../../domain/use_cases/fetch_set_words_for_repeating_training.dart';
import '../../../domain/use_cases/fetch_set_words_for_wt_training.dart';
import '../../../domain/use_cases/fetch_words_for_cards_training.dart';
import '../../../domain/use_cases/fetch_words_for_dictant_training.dart';
import '../../../domain/use_cases/fetch_words_for_repeating_training.dart';
import '../../../domain/use_cases/update_words_for_cards_training.dart';
import '../../../domain/use_cases/update_words_for_dictant_training.dart';
import '../../../domain/use_cases/update_words_for_repeating_trainings.dart';

const serverFailureMessage = 'Server Failure';

// BLoC 8.0.0
class TrainingsBloc extends Bloc<TrainingsEvent, TrainingsState> {
  final usecase1.FetchWordsForWTTraining fetchWordsForWtTraining;
  final usecase2.AddSuggestedTranslationsToWordsInWT
      addSuggestedTranslationsToWordsInWT;
  final usecase3.UpdateWordsForWTTraining updateWordsForWTTraining;
  final usecase4.AddSuggestedSourcesToWordsInTW addSuggestedSourcesToWordsInTW;
  final usecase5.FetchWordsForTWTraining fetchWordsForTwTRainings;
  final usecase6.UpdateWordsForTWTraining updateWordsForTWTraining;
  final usecase7.FetchWordsForMatchingTraining fetchWordsForMatchingTRaining;
  final usecase8.UpdateWordsForMatchingTraining updateWordsForMatchingTraining;
  final FetchWordsForDictantTraining fetchWordsForDictantTraining;
  final UpdateWordsForDictantTraining updateWordsForDictantTraining;
  final FetchWordsForCardsTraining fetchWordsForCardsTraining;
  final UpdateWordsForCardsTraining updateWordsForCardsTraining;
  final FetchWordsForRepeatingTraining fetchWordsForRepeatingTraining;
  final UpdateWordsForRepeatingTraining updateWordsForRepeatingTraining;
  final FetchSetWordsForTWTraining fetchSetWordsForTwTRainings;
  final FetchSetWordsForWTTraining fetchSetWordsForWTTraining;
  final FetchSetWordsForMatchingTraining fetchSetWordsForMatchingTraining;
  final FetchSetWordsForCardsTraining fetchSetWordsForCardsTraining;
  final FetchSetWordsForDictantTraining fetchSetWordsForDictantTraining;
  final FetchSetWordsForRepeatingTraining fetchSetWordsForRepeatingTraining;

  TrainingsBloc({
    required this.fetchWordsForWtTraining,
    required this.addSuggestedTranslationsToWordsInWT,
    required this.updateWordsForWTTraining,
    required this.fetchWordsForTwTRainings,
    required this.addSuggestedSourcesToWordsInTW,
    required this.updateWordsForTWTraining,
    required this.fetchWordsForMatchingTRaining,
    required this.updateWordsForMatchingTraining,
    required this.fetchWordsForDictantTraining,
    required this.updateWordsForDictantTraining,
    required this.fetchWordsForCardsTraining,
    required this.updateWordsForCardsTraining,
    required this.fetchWordsForRepeatingTraining,
    required this.updateWordsForRepeatingTraining,
    required this.fetchSetWordsForTwTRainings,
    required this.fetchSetWordsForWTTraining,
    required this.fetchSetWordsForMatchingTraining,
    required this.fetchSetWordsForDictantTraining,
    required this.fetchSetWordsForRepeatingTraining,
    required this.fetchSetWordsForCardsTraining,
  }) : super(TrainingLoading()) {
    on<FetchWordsForWtTRainings>(_onFetchWordsForWtTRainingsEvent);
    on<FetchWordsForTwTRainings>(_onFetchWordsForTwTRainingsEvent);
    on<FetchWordsForMatchingTRainings>(_onFetchWordsForMatchingTRainingsEvent);
    on<FetchWordsForDictantTRainings>(_onFetchWordsForDictantTRainingsEvent);
    on<FetchWordsForCardsTRainings>(_onFetchWordsForCardsTRainingsEvent);
    on<FetchWordsForRepeatingTRainings>(
        _onFetchWordsForRepeatingTRainingsEvent);
    on<FetchSetWordsForWtTRainings>(_onFetchSetWordsForWtTRainingsEvent);
    on<FetchSetWordsForTwTRainings>(_onFetchSetWordsForTwTRainingsEvent);
    on<FetchSetWordsForMatchingTRainings>(
        _onFetchSetWordsForMatchingTRainingsEvent);
    on<FetchSetWordsForDictantTRainings>(
        _onFetchSetWordsForDictantTRainingsEvent);
    on<FetchSetWordsForCardsTRainings>(_onFetchSetWordsForCardsTRainingsEvent);
    on<FetchSetWordsForRepeatingTRainings>(
        _onFetchSetWordsForRepeatingTRainingsEvent);
    on<AddSuggestedTranslationsToWordsInWT>(
        _onAddSuggestedTranslationsToWordsInWTEvent);
    on<AddSuggestedSourcesToWordsInTW>(_onAddSuggestedSourcesToWordsInTWEvent);
    on<UpdateWordsForWtTRainings>(_onUpdateWordsForWtTRainingsEvent);
    on<UpdateWordsForTwTRainings>(_onUpdateWordsForTwTRainingsEvent);
    on<UpdateWordsForMatchingTRainings>(
        _onUpdateWordsForMatchingTRainingsEvent);
    on<UpdateWordsForDictantTRainings>(_onUpdateWordsForDictantTRainingsEvent);
    on<UpdateWordsForCardsTRainings>(_onUpdateWordsForCardsTRainingsEvent);
    on<UpdateWordsForRepeatingTRainings>(
        _onUpdateWordsForRepeatingTRainingsEvent);
  }

  FutureOr<void> _onFetchWordsForWtTRainingsEvent(
      FetchWordsForWtTRainings event, Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchWordsForWtTraining();

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

  FutureOr<void> _onFetchSetWordsForWtTRainingsEvent(
      FetchSetWordsForWtTRainings event, Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchSetWordsForWTTraining(event.setId);

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

  FutureOr<void> _onFetchWordsForRepeatingTRainingsEvent(
      FetchWordsForRepeatingTRainings event,
      Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchWordsForRepeatingTraining();

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        emit(RepeatingTrainingLoaded(words: words));
      }
    });
  }

  FutureOr<void> _onFetchSetWordsForRepeatingTRainingsEvent(
      FetchSetWordsForRepeatingTRainings event,
      Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchSetWordsForRepeatingTraining(event.setId);

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        emit(RepeatingTrainingLoaded(
          words: words,
        ));
      }
    });
  }

  FutureOr<void> _onFetchWordsForCardsTRainingsEvent(
      FetchWordsForCardsTRainings event, Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchWordsForCardsTraining();

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        emit(CardsTrainingLoaded(words: words));
      }
    });
  }

  FutureOr<void> _onFetchSetWordsForCardsTRainingsEvent(
      FetchSetWordsForCardsTRainings event,
      Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchSetWordsForCardsTraining(event.setId);

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        emit(CardsTrainingLoaded(
          words: words,
        ));
      }
    });
  }

  FutureOr<void> _onFetchWordsForMatchingTRainingsEvent(
      FetchWordsForMatchingTRainings event,
      Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchWordsForMatchingTRaining();

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        emit(MatchingTrainingLoaded(words: words));
      }
    });
  }

  FutureOr<void> _onFetchSetWordsForMatchingTRainingsEvent(
      FetchSetWordsForMatchingTRainings event,
      Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchSetWordsForMatchingTraining(event.setId);

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        emit(MatchingTrainingLoaded(words: words));
      }
    });
  }

  FutureOr<void> _onFetchWordsForDictantTRainingsEvent(
      FetchWordsForDictantTRainings event, Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchWordsForDictantTraining();

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        emit(DictantTrainingLoaded(words: words));
      }
    });
  }

  FutureOr<void> _onFetchSetWordsForDictantTRainingsEvent(
      FetchSetWordsForDictantTRainings event,
      Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchSetWordsForDictantTraining(event.setId);

    failureOrWords.fold(
        (error) => emit(TrainingError(message: _mapFailureToMessage(error))),
        (words) {
      if (words.isEmpty) {
        emit(TrainingEmpty());
      } else {
        emit(DictantTrainingLoaded(
          words: words,
        ));
      }
    });
  }

  FutureOr<void> _onFetchWordsForTwTRainingsEvent(
      FetchWordsForTwTRainings event, Emitter<TrainingsState> emit) async {
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

  FutureOr<void> _onFetchSetWordsForTwTRainingsEvent(
      FetchSetWordsForTwTRainings event, Emitter<TrainingsState> emit) async {
    emit(TrainingLoading());

    final failureOrWords = await fetchSetWordsForTwTRainings(event.setId);

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
    await updateWordsForWTTraining(event.toUpdate);
  }

  FutureOr<void> _onUpdateWordsForTwTRainingsEvent(
      UpdateWordsForTwTRainings event, Emitter<TrainingsState> emit) async {
    await updateWordsForTWTraining(event.toUpdate);
  }

  FutureOr<void> _onUpdateWordsForMatchingTRainingsEvent(
      UpdateWordsForMatchingTRainings event,
      Emitter<TrainingsState> emit) async {
    await updateWordsForMatchingTraining(event.toUpdate);
  }

  FutureOr<void> _onUpdateWordsForDictantTRainingsEvent(
      UpdateWordsForDictantTRainings event,
      Emitter<TrainingsState> emit) async {
    await updateWordsForDictantTraining(event.toUpdate);
  }

  FutureOr<void> _onUpdateWordsForCardsTRainingsEvent(
      UpdateWordsForCardsTRainings event, Emitter<TrainingsState> emit) async {
    await updateWordsForCardsTraining(event.toUpdate);
  }

  FutureOr<void> _onUpdateWordsForRepeatingTRainingsEvent(
      UpdateWordsForRepeatingTRainings event,
      Emitter<TrainingsState> emit) async {
    await updateWordsForRepeatingTraining(event.mistakes, event.correctAnswers);
  }

  FutureOr<void> _onAddSuggestedTranslationsToWordsInWTEvent(
      AddSuggestedTranslationsToWordsInWT event,
      Emitter<TrainingsState> emit) async {
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
        return serverFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
