import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/exception.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/data/datasources/word_local_datasource.dart';
import 'package:pro_dictant/features/dictionary/data/datasources/word_remote_datasource.dart';
import 'package:pro_dictant/features/dictionary/data/models/translation_model.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
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
      TranslationEntity translationModel) async {
    try {
      await localDataSource
          .deleteWordFromDictionary(translationModel as TranslationModel);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTranslation(
      TranslationEntity translationModel) async {
    try {
      await localDataSource
          .deleteTranslation(translationModel as TranslationModel);
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

  @override
  Future<Either<Failure, List<WordModel>>> fetchWordBySource(
      String source) async {
    try {
      List<WordModel> word = await localDataSource.fetchWordBySource(source);
      return Right(word);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> searchWordForASet(
      String query) async {
    try {
      final words = await localDataSource.searchWordForASet(query);
      return Right(words);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateTranslation(
      TranslationEntity translationEntity) async {
    try {
      await localDataSource
          .updateTranslation(translationEntity as TranslationModel);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> fetchTranslationsForWords(
      List<WordEntity> words) async {
    try {
      List<WordModel> wordsModels = [];
      words.forEach((element) {
        wordsModels.add(WordModel(
            id: element.id,
            source: element.source,
            pos: element.pos,
            transcription: element.transcription));
      });
      final wordsWithTranslations =
          await localDataSource.fetchTranslationsForWords(wordsModels);
      return Right(wordsWithTranslations);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addTranslation(
      TranslationEntity translationEntity) async {
    try {
      TranslationModel translationModel = TranslationModel(
          id: translationEntity.id,
          wordId: translationEntity.wordId,
          translation: translationEntity.translation,
          notes: translationEntity.notes);
      await localDataSource.addTranslation(translationModel);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> fetchTranslationsForWordsInSet(
      List<WordEntity> words, String setId) async {
    try {
      List<WordModel> wordsModels = [];
      words.forEach((element) {
        wordsModels.add(WordModel(
            id: element.id,
            source: element.source,
            pos: element.pos,
            transcription: element.transcription));
      });
      final wordsWithTranslations = await localDataSource
          .fetchTranslationsForWordsInSet(wordsModels, setId);
      return Right(wordsWithTranslations);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>>
      fetchTranslationsForSearchedWordsInSet(List<WordEntity> words) async {
    try {
      List<WordModel> wordsModels = [];
      words.forEach((element) {
        wordsModels.add(WordModel(
            id: element.id,
            source: element.source,
            pos: element.pos,
            transcription: element.transcription));
      });
      final wordsWithTranslations = await localDataSource
          .fetchTranslationsForSearchedWordsInSet(wordsModels);
      return Right(wordsWithTranslations);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addWordsFromSetToDictionary(
      List<TranslationEntity> words) async {
    List<TranslationModel> wordsModels = [];
    words.forEach((translationEntity) {
      wordsModels.add(TranslationModel(
          id: translationEntity.id,
          wordId: translationEntity.wordId,
          translation: translationEntity.translation,
          notes: translationEntity.notes));
    });
    try {
      await localDataSource.addWordsFromSetToDictionary(wordsModels);
      return const Right(Future<void>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
