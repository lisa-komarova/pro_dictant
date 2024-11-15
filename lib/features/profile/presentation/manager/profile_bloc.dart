import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/profile/domain/use_cases/fetch_statistics.dart';
import 'package:pro_dictant/features/profile/domain/use_cases/update_day_statistics.dart'
    as usecase2;
import 'package:pro_dictant/features/profile/domain/use_cases/update_goal.dart'
    as usecase3;
import 'package:pro_dictant/features/profile/presentation/manager/profile_event.dart';
import 'package:pro_dictant/features/profile/presentation/manager/profile_state.dart';

const serverFailureMessage = 'Server Failure';

// BLoC 8.0.0
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FetchStatistics fetchStatistics;
  final usecase2.UpdateDayStatistics updateDayStatistics;
  final usecase3.UpdateGoal updateGoal;

  ProfileBloc({
    required this.fetchStatistics,
    required this.updateDayStatistics,
    required this.updateGoal,
  }) : super(ProfileLoading()) {
    on<LoadStatistics>(_onLoadStatisticsEvent);
    on<UpdateDayStatistics>(_onUpdateDayStatisticsEvent);
    on<UpdateGoal>(_onUpdateGoalEvent);
  }

  FutureOr<void> _onLoadStatisticsEvent(
      LoadStatistics event, Emitter<ProfileState> emit) async {
    //TODO check what it's for
    //if (state is WordsLoading) return;

    emit(ProfileLoading());

    final failureOrSets = await fetchStatistics();

    failureOrSets.fold(
        (error) => emit(ProfileError(message: _mapFailureToMessage(error))),
        (statistics) {
      if (statistics == null) {
        emit(ProfileEmpty());
      } else {
        emit(ProfileLoaded(statistics: statistics));
      }
    });
  }

  FutureOr<void> _onUpdateDayStatisticsEvent(
      UpdateDayStatistics event, Emitter<ProfileState> emit) async {
    final failureOrSets = await updateDayStatistics(event.date);

    failureOrSets.fold(
        (error) => emit(ProfileError(message: _mapFailureToMessage(error))),
        (statistics) {
      if (statistics == null) {
        emit(ProfileEmpty());
      } else {
        emit(ProfileLoaded(statistics: statistics));
      }
    });
  }

  FutureOr<void> _onUpdateGoalEvent(
      UpdateGoal event, Emitter<ProfileState> emit) async {
    final failureOrSets = await updateGoal(event.goalInMinutes);
    emit(ProfileLoading());
    failureOrSets.fold(
        (error) => emit(ProfileError(message: _mapFailureToMessage(error))),
        (statistics) {
      if (statistics == null) {
        emit(ProfileEmpty());
      } else {
        emit(ProfileLoaded(statistics: statistics));
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
