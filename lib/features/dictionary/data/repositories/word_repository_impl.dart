import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/exception.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/data/datasources/word_local_datasource.dart';
import 'package:pro_dictant/features/dictionary/data/datasources/word_remote_datasource.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/word_repository.dart';

class WordRepositoryImpl extends WordRepository {
  final WordRemoteDatasource remoteDataSource;
  final WordLocalDatasource localDataSource;

  WordRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<WordEntity>>> getAllWordsInDict() async {
    try {
      final wordsInDict = await localDataSource.fetchWordsInDict();
      return Right(wordsInDict);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> filterWords(
      String query, bool isNew, bool isLearning, bool isLearnt) async {
    List<WordEntity> wordsInDict = [];
    try {
      if (query.isNotEmpty) {
        wordsInDict = await localDataSource.filterWordsInDict(query);
      } else if (isNew) {
        wordsInDict = await localDataSource.getNewWords();
      } else if (isLearning) {
        wordsInDict = await localDataSource.getLearningWords();
      } else if (isLearnt) {
        wordsInDict = await localDataSource.getLearntWords();
      } else if (query.isEmpty && !isNew && !isLearning && !isLearnt) {
        wordsInDict = await localDataSource.fetchWordsInDict();
      }
      return Right(wordsInDict);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteWordFromDictionary(
      WordEntity word) async {
    try {
      await localDataSource.deleteWordFromDictionary(word as WordModel);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteWord(String wordId) async {
    try {
      await localDataSource.deleteWord(wordId);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateWord(WordEntity word) async {
    try {
      await localDataSource.updateWord(word as WordModel);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addWord(WordEntity word) async {
    try {
      await localDataSource.addWord(word as WordModel);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
