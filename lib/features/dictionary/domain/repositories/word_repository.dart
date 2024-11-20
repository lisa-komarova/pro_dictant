import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';

abstract class WordRepository {
  Future<Either<Failure, List<WordEntity>>> getAllWordsInDict();

  Future<Either<Failure, List<WordEntity>>> fetchWordBySource(String source);

  Future<Either<Failure, List<WordEntity>>> fetchTranslationsForWords(
      List<WordEntity> words);

  Future<Either<Failure, List<WordEntity>>> fetchTranslationsForWordsInSet(
      List<WordEntity> words, String setId);

  Future<Either<Failure, List<WordEntity>>>
      fetchTranslationsForSearchedWordsInSet(List<WordEntity> words);

  Future<Either<Failure, List<WordEntity>>> filterWords(
      String query, bool isNew, bool isLearning, bool isLearnt);

  Future<Either<Failure, List<WordEntity>>> searchWordForASet(String query);

  Future<Either<Failure, void>> updateWord(WordEntity word);

  Future<Either<Failure, void>> addWord(WordEntity word);

  Future<Either<Failure, void>> addWordsInSetToDictionary(
      List<TranslationEntity> words);

  Future<Either<Failure, void>> removeWordsInSetFromDictionary(
      List<TranslationEntity> words);

  Future<Either<Failure, void>> deleteWordFromDictionary(
      TranslationEntity translationModel);

  Future<Either<Failure, void>> deleteTranslation(
      TranslationEntity translationEntity);

  Future<Either<Failure, void>> addTranslation(
      TranslationEntity translationEntity);

  Future<Either<Failure, void>> deleteWord(WordEntity wordEntity);

  Future<Either<Failure, void>> updateTranslation(
      TranslationEntity translationEntity);
}
