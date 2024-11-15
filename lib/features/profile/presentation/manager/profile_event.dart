import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadStatistics extends ProfileEvent {
  const LoadStatistics();
}

class UpdateDayStatistics extends ProfileEvent {
  final DateTime date;

  const UpdateDayStatistics({required this.date});
}

class UpdateGoal extends ProfileEvent {
  final int goalInMinutes;

  const UpdateGoal({required this.goalInMinutes});
}

class UpdateTimeOnApp extends ProfileEvent {
  final int time;

  const UpdateTimeOnApp({required this.time});
}
