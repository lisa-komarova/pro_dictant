import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

import '../entities/dictant_training_entity.dart';

class FetchSetWordsForDictantTraining {
  final TrainingsRepository trainingsRepository;

  FetchSetWordsForDictantTraining({required this.trainingsRepository});

  Future<Either<Failure, List<DictantTrainingEntity>>> call(
      String setId) async {
    return await trainingsRepository.fetchSetWordsForDictantTraining(setId);
  }
}
