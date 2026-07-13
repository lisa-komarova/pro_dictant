import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_card_info_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';

abstract class SetsState extends Equatable {
  const SetsState();

  @override
  List<Object> get props => [];
}

class SetsEmpty extends SetsState {}

class SetsLoading extends SetsState {}

class SetsWithWordsLoaded extends SetsState {
  final List<SetEntity> sets;

  const SetsWithWordsLoaded({required this.sets});

  @override
  List<Object> get props => [sets];
}


class SetsLoaded extends SetsState {
  final List<SetCardInfoEntity> sets;

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
