import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

import '../entities/cards_training_entity.dart';

class FetchWordsForCardsTraining {
  final TrainingsRepository trainingsRepository;

  FetchWordsForCardsTraining({required this.trainingsRepository});

  Future<Either<Failure, List<CardsTrainingEntity>>> call() async {
    return await trainingsRepository.fetchWordsForCardsTraining();
  }
}
