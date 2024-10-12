import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

import '../entities/dictant_training_entity.dart';

class UpdateWordsForDictantTraining {
  final TrainingsRepository trainingsRepository;

  UpdateWordsForDictantTraining({required this.trainingsRepository});

  Future<Either<Failure, void>> call(
      List<DictantTrainingEntity> toUpdate) async {
    return await trainingsRepository.updateWordsForDictantTraining(toUpdate);
  }
}
