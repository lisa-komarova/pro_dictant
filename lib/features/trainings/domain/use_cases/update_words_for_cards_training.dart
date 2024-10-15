import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

import '../entities/cards_training_entity.dart';

class UpdateWordsForCardsTraining {
  final TrainingsRepository trainingsRepository;

  UpdateWordsForCardsTraining({required this.trainingsRepository});

  Future<Either<Failure, void>> call(List<CardsTrainingEntity> toUpdate) async {
    return await trainingsRepository.updateWordsForCardsTraining(toUpdate);
  }
}
