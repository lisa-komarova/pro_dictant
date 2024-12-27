import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

class FetchSetWordsForWTTraining {
  final TrainingsRepository trainingsRepository;

  FetchSetWordsForWTTraining({required this.trainingsRepository});

  Future<Either<Failure, List<WTTrainingEntity>>> call(String setId) async {
    return await trainingsRepository.fetchSetWordsForWTTraining(setId);
  }
}
