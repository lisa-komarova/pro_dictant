import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

import '../entities/tw_training_entity.dart';

class FetchSetWordsForTWTraining {
  final TrainingsRepository trainingsRepository;

  FetchSetWordsForTWTraining({required this.trainingsRepository});

  Future<Either<Failure, List<TWTrainingEntity>>> call(String setId) async {
    return await trainingsRepository.fetchSetWordsForTWTraining(setId);
  }
}
