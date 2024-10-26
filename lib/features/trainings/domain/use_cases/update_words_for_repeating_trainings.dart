import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/entities/repeating_entity.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

class UpdateWordsForRepeatingTraining {
  final TrainingsRepository trainingsRepository;

  UpdateWordsForRepeatingTraining({required this.trainingsRepository});

  Future<Either<Failure, void>> call(List<RepeatingTrainingEntity> mistakes,
      List<RepeatingTrainingEntity> correctAnswers) async {
    return await trainingsRepository.updateWordsForRepeatingTraining(
        mistakes, correctAnswers);
  }
}
