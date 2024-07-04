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
      final wordsInDict = await localDataSource.readWordsInDict();
      return Right(wordsInDict);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> filterWords(String query) async {
    try {
      final wordsInDict = await localDataSource.filterWordsInDict(query);
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
  Future<Either<Failure, List<WordEntity>>> getLearningWords() async {
    try {
      final wordsInDict = await localDataSource.getLearningWords();
      return Right(wordsInDict);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> getLearntWords() async {
    try {
      final wordsInDict = await localDataSource.getLearntWords();
      return Right(wordsInDict);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> getNewWords() async {
    try {
      final wordsInDict = await localDataSource.getNewWords();
      return Right(wordsInDict);
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
