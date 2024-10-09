import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

import '../entities/tw_training_entity.dart';

class AddSuggestedSourcesToWordsInTW {
  final TrainingsRepository trainingsRepository;

  AddSuggestedSourcesToWordsInTW({required this.trainingsRepository});

  Future<Either<Failure, List<TWTrainingEntity>>> call(
      List<TWTrainingEntity> words) async {
    return await trainingsRepository.addSuggestedSourcesToWordsInTW(words);
  }
}
