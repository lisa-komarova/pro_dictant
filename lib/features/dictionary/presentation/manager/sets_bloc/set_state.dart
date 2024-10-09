import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';

abstract class SetsState extends Equatable {
  const SetsState();

  @override
  List<Object> get props => [];
}

class SetsEmpty extends SetsState {}

class SetsLoading extends SetsState {}

class SetsLoaded extends SetsState {
  final List<SetEntity> sets;

  const SetsLoaded({required this.sets});

  @override
  List<Object> get props => [sets];
}

class SetLoading extends SetsState {}

class SetLoaded extends SetsState {
  final SetEntity set;

  const SetLoaded({required this.set});

  @override
  List<Object> get props => [set];
}

class SetsError extends SetsState {
  final String message;

  const SetsError({required this.message});

  @override
  List<Object> get props => [message];
}
