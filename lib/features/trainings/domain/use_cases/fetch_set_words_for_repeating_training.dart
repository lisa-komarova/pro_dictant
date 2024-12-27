import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/entities/repeating_entity.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

class FetchSetWordsForRepeatingTraining {
  final TrainingsRepository trainingsRepository;

  FetchSetWordsForRepeatingTraining({required this.trainingsRepository});

  Future<Either<Failure, List<RepeatingTrainingEntity>>> call(
      String setId) async {
    return await trainingsRepository.fetchSetWordsForRepeatingTraining(setId);
  }
}
