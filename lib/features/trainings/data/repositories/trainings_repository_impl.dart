import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/exception.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/data/data_sources/trainings_datasource.dart';
import 'package:pro_dictant/features/trainings/data/models/matching_training_model.dart';
import 'package:pro_dictant/features/trainings/data/models/wt_training_model.dart';
import 'package:pro_dictant/features/trainings/domain/entities/matching_training_entity.dart';
import 'package:pro_dictant/features/trainings/domain/entities/repeating_entity.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

import '../../domain/entities/cards_training_entity.dart';
import '../../domain/entities/dictant_training_entity.dart';
import '../../domain/entities/tw_training_entity.dart';
import '../models/cards_translation_model.dart';
import '../models/dictant_training_model.dart';
import '../models/repeating_training_model.dart';
import '../models/tw_training_model.dart';

class TrainingsRepositoryImpl extends TrainingsRepository {
  final TrainingsDatasource trainingsDataSource;

  TrainingsRepositoryImpl({required this.trainingsDataSource});

  @override
  Future<Either<Failure, List<WTTrainingEntity>>>
      fetchWordsForWTTraining() async {
    try {
      final wtWords = await trainingsDataSource.fetchWordsForWTTraining();
      return Right(wtWords);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WTTrainingEntity>>>
      addSuggestedTranslationsToWordsInWT(List<WTTrainingEntity> words) async {
    try {
      List<WTTraningModel> wordsModel = [];
      words.forEach((element) {
        WTTraningModel newModel = WTTraningModel(
            id: element.id,
            source: element.source,
            translation: element.translation);
        wordsModel.add(newModel);
      });

      final modifiedWords = await trainingsDataSource
          .addSuggestedTranslationsToWordsInWT(wordsModel);
      return Right(modifiedWords);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateWordsForWTTraining(
      List<String> toUpdate) async {
    try {
      await trainingsDataSource.updateWordsForWTTraining(toUpdate);
      return Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateWordsForTWTraining(
      List<String> toUpdate) async {
    try {
      await trainingsDataSource.updateWordsForTWTraining(toUpdate);
      return Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<TWTrainingEntity>>>
      fetchWordsForTWTraining() async {
    try {
      final twWords = await trainingsDataSource.fetchWordsForTWTraining();
      return Right(twWords);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CardsTrainingEntity>>>
      fetchWordsForCardsTraining() async {
    try {
      final cardsWords = await trainingsDataSource.fetchWordsForCardsTraining();
      return Right(cardsWords);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<TWTrainingEntity>>>
      addSuggestedSourcesToWordsInTW(List<TWTrainingEntity> words) async {
    try {
      List<TWTraningModel> wordsModel = [];
      words.forEach((element) {
        TWTraningModel newModel = TWTraningModel(
            id: element.id,
            source: element.source,
            translation: element.translation);
        wordsModel.add(newModel);
      });

      final modifiedWords =
          await trainingsDataSource.addSuggestedSourcesToWordsInTW(wordsModel);
      return Right(modifiedWords);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MatchingTrainingEntity>>>
      fetchWordsForMatchingTraining() async {
    try {
      final twWords = await trainingsDataSource.fetchWordsForMatchingTraining();
      return Right(twWords);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateWordsForMatchingTraining(
      List<MatchingTrainingEntity> toUpdate) async {
    List<MatchingTrainingModel> toUpdateModels = [];
    toUpdate.forEach((element) {
      MatchingTrainingModel model = MatchingTrainingModel(
          id: element.id,
          source: element.source,
          translation: element.translation);
      toUpdateModels.add(model);
    });
    try {
      await trainingsDataSource.updateWordsForMatchingTraining(toUpdateModels);
      return Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateWordsForDictantTraining(
      List<DictantTrainingEntity> toUpdate) async {
    List<DictantTrainingModel> toUpdateModels = [];
    toUpdate.forEach((element) {
      DictantTrainingModel model = DictantTrainingModel(
          id: element.id,
          source: element.source,
          translation: element.translation);
      toUpdateModels.add(model);
    });
    try {
      await trainingsDataSource.updateWordsForDictantTraining(toUpdateModels);
      return Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateWordsForCardsTraining(
      List<CardsTrainingEntity> toUpdate) async {
    List<CardsTrainingModel> toUpdateModels = [];
    toUpdate.forEach((element) {
      CardsTrainingModel model = CardsTrainingModel(
          id: element.id,
          source: element.source,
          translation: element.translation,
          wrongTranslation: element.wrongTranslation);
      toUpdateModels.add(model);
    });
    try {
      await trainingsDataSource.updateWordsForCardsTraining(toUpdateModels);
      return Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateWordsForRepeatingTraining(
    List<RepeatingTrainingEntity> mistakes,
    List<RepeatingTrainingEntity> correctAnswers,
  ) async {
    List<RepeatingTrainingModel> mistakesModels = [];
    mistakes.forEach((element) {
      RepeatingTrainingModel model = RepeatingTrainingModel(
        id: element.id,
        source: element.source,
      );
      mistakesModels.add(model);
    });
    List<RepeatingTrainingModel> correctAnswersModels = [];
    correctAnswers.forEach((element) {
      RepeatingTrainingModel model = RepeatingTrainingModel(
        id: element.id,
        source: element.source,
      );
      correctAnswersModels.add(model);
    });
    try {
      await trainingsDataSource.updateWordsForRepeatingTraining(
          mistakesModels, correctAnswersModels);
      return Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<DictantTrainingEntity>>>
      fetchWordsForDictantTraining() async {
    try {
      final dictantWords =
          await trainingsDataSource.fetchWordsForDictantTraining();
      return Right(dictantWords);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<RepeatingTrainingEntity>>>
      fetchWordsForRepeatingTraining() async {
    try {
      final repetingWords =
          await trainingsDataSource.fetchWordsForRepeatingTraining();
      return Right(repetingWords);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
