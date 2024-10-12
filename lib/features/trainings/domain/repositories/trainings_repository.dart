import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';

import '../entities/dictant_training_entity.dart';
import '../entities/matching_training_entity.dart';
import '../entities/tw_training_entity.dart';

abstract class TrainingsRepository {
  Future<Either<Failure, List<WTTrainingEntity>>> fetchWordsForWTTraining();

  Future<Either<Failure, List<TWTrainingEntity>>> fetchWordsForTWTraining();

  Future<Either<Failure, void>> updateWordsForWTTraining(List<String> toUpdate);

  Future<Either<Failure, void>> updateWordsForTWTraining(List<String> toUpdate);

  Future<Either<Failure, void>> updateWordsForDictantTraining(
      List<DictantTrainingEntity> toUpdate);

  Future<Either<Failure, List<WTTrainingEntity>>>
      addSuggestedTranslationsToWordsInWT(List<WTTrainingEntity> words);

  Future<Either<Failure, List<TWTrainingEntity>>>
      addSuggestedSourcesToWordsInTW(List<TWTrainingEntity> words);

  Future<Either<Failure, List<MatchingTrainingEntity>>>
      fetchWordsForMatchingTraining();

  Future<Either<Failure, List<DictantTrainingEntity>>>
      fetchWordsForDictantTraining();

  Future<Either<Failure, void>> updateWordsForMatchingTraining(
      List<MatchingTrainingEntity> toUpdate);
}
