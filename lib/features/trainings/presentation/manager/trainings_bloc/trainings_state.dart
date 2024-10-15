import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/trainings/domain/entities/tw_training_entity.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';

import '../../../domain/entities/cards_training_entity.dart';
import '../../../domain/entities/dictant_training_entity.dart';
import '../../../domain/entities/matching_training_entity.dart';

abstract class TrainingsState extends Equatable {
  const TrainingsState();

  @override
  List<Object> get props => [];
}

class TrainingEmpty extends TrainingsState {}

class TrainingLoading extends TrainingsState {}

class WTTrainingLoaded extends TrainingsState {
  final List<WTTrainingEntity> words;

  const WTTrainingLoaded({required this.words});

  @override
  List<Object> get props => [words];
}

class TWTrainingLoaded extends TrainingsState {
  final List<TWTrainingEntity> words;

  const TWTrainingLoaded({required this.words});

  @override
  List<Object> get props => [words];
}

class CardsTrainingLoaded extends TrainingsState {
  final List<CardsTrainingEntity> words;

  const CardsTrainingLoaded({required this.words});

  @override
  List<Object> get props => [words];
}

class DictantTrainingLoaded extends TrainingsState {
  final List<DictantTrainingEntity> words;

  const DictantTrainingLoaded({required this.words});

  @override
  List<Object> get props => [words];
}

class MatchingTrainingLoaded extends TrainingsState {
  final List<MatchingTrainingEntity> words;

  const MatchingTrainingLoaded({required this.words});

  @override
  List<Object> get props => [words];
}

class TrainingError extends TrainingsState {
  final String message;

  const TrainingError({required this.message});

  @override
  List<Object> get props => [message];
}
