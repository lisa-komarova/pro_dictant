import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/data/datasources/word_local_datasource.dart';
import 'package:pro_dictant/features/dictionary/data/models/set_model.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_card_info_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/set_repository.dart';

import '../../../../core/error/exception.dart';
import '../../domain/entities/set_entity.dart';
import '../../domain/entities/word_entity.dart';

class SetRepositoryImpl extends SetRepository {
  final WordLocalDatasource localDataSource;

  SetRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SetCardInfoEntity>>> loadSets() async {
    try {
      final sets = await localDataSource.fetchSets();
      final entities = sets
          .map((record) => SetCardInfoEntity(
              id: record.$1, name: record.$2, numberOfWords: record.$3))
          .toList();
      return Right(entities);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addSet(SetEntity set) async {
    try {
      SetModel setModel = SetModel(
          id: set.id,
          name: set.name,
          isAddedToDictionary: set.isAddedToDictionary,
          wordsInSet: set.wordsInSet);
      await localDataSource.addSet(setModel);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteSet(String setId) async {
    try {
      await localDataSource.deleteSet(setId);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateSet(
      SetEntity set, List<WordEntity> toAdd, List<WordEntity> toDelete) async {
    SetModel setModel = SetModel(
        id: set.id,
        name: set.name,
        isAddedToDictionary: set.isAddedToDictionary,
        wordsInSet: set.wordsInSet);
    List<WordModel> toAddModels = [];
    List<WordModel> toDeleteModels = [];
    for (var i = 0; i < toAdd.length; i++) {
      toAddModels.add(WordModel(
        id: toAdd[i].id,
        source: toAdd[i].source,
        pos: toAdd[i].pos,
        transcription: toAdd[i].transcription,
      ));
      toAddModels[i].translationList.addAll(toAdd[i].translationList);
    }
    for (var i = 0; i < toDelete.length; i++) {
      toDeleteModels.add(WordModel(
        id: toDelete[i].id,
        source: toDelete[i].source,
        pos: toDelete[i].pos,
        transcription: toDelete[i].transcription,
      ));
      toDeleteModels[i].translationList.addAll(toDelete[i].translationList);
    }
    try {
      await localDataSource.updateSet(setModel, toAddModels, toDeleteModels);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SetEntity>> fetchSetWithWords(String setId) async {
    try {
      final set = await localDataSource.fetchSetWithWords(setId);
      return Right(set);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
