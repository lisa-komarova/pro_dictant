import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

import '../entities/dictant_training_entity.dart';

class FetchWordsForDictantTraining {
  final TrainingsRepository trainingsRepository;

  FetchWordsForDictantTraining({required this.trainingsRepository});

  Future<Either<Failure, List<DictantTrainingEntity>>> call() async {
    return await trainingsRepository.fetchWordsForDictantTraining();
  }
}
