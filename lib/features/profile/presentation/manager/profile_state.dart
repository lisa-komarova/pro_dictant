import 'package:equatable/equatable.dart';

import '../../domain/entities/statistics_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileEmpty extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final StatisticsEntity statistics;

  const ProfileLoaded({required this.statistics});

  @override
  List<Object> get props => [statistics];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}
