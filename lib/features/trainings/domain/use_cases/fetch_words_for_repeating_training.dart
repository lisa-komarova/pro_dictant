import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/entities/repeating_entity.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

class FetchWordsForRepeatingTraining {
  final TrainingsRepository trainingsRepository;

  FetchWordsForRepeatingTraining({required this.trainingsRepository});

  Future<Either<Failure, List<RepeatingTrainingEntity>>> call() async {
    return await trainingsRepository.fetchWordsForRepeatingTraining();
  }
}
