import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

class UpdateWordsForTWTraining {
  final TrainingsRepository trainingsRepository;

  UpdateWordsForTWTraining({required this.trainingsRepository});

  Future<Either<Failure, void>> call(List<String> toUpdate) async {
    return await trainingsRepository.updateWordsForTWTraining(toUpdate);
  }
}
