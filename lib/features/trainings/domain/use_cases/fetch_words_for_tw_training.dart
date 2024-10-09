import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

import '../entities/tw_training_entity.dart';

class FetchWordsForTWTraining {
  final TrainingsRepository trainingsRepository;

  FetchWordsForTWTraining({required this.trainingsRepository});

  Future<Either<Failure, List<TWTrainingEntity>>> call() async {
    return await trainingsRepository.fetchWordsForTWTraining();
  }
}
