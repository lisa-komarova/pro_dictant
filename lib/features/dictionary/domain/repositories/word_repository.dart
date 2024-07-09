import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';

abstract class WordRepository {
  Future<Either<Failure, List<WordEntity>>> getAllWordsInDict();

  Future<Either<Failure, List<WordEntity>>> filterWords(
      String query, bool isNew, bool isLearning, bool isLearnt);

  Future<Either<Failure, void>> updateWord(WordEntity word);

  Future<Either<Failure, void>> addWord(WordEntity word);

  Future<Either<Failure, void>> deleteWordFromDictionary(WordEntity word);

  Future<Either<Failure, void>> deleteWord(String wordId);
}
