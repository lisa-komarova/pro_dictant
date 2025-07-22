import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

import '../entities/combo_training_entity.dart';

class FetchWordsForComboTraining {
  final TrainingsRepository trainingsRepository;

  FetchWordsForComboTraining({required this.trainingsRepository});

  Future<Either<Failure, List<ComboTrainingEntity>>> call() async {
    return await trainingsRepository.fetchWordsForComboTraining();
  }
}
