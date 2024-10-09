import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

class AddSuggestedTranslationsToWordsInWT {
  final TrainingsRepository trainingsRepository;

  AddSuggestedTranslationsToWordsInWT({required this.trainingsRepository});

  Future<Either<Failure, List<WTTrainingEntity>>> call(
      List<WTTrainingEntity> words) async {
    return await trainingsRepository.addSuggestedTranslationsToWordsInWT(words);
  }
}
