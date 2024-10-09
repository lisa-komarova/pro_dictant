import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/entities/matching_training_entity.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

class UpdateWordsForMatchingTraining {
  final TrainingsRepository trainingsRepository;

  UpdateWordsForMatchingTraining({required this.trainingsRepository});

  Future<Either<Failure, void>> call(
      List<MatchingTrainingEntity> toUpdate) async {
    return await trainingsRepository.updateWordsForMatchingTraining(toUpdate);
  }
}
