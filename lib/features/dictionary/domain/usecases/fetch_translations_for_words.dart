import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/word_repository.dart';

class FetchTranslationsForWords {
  final WordRepository wordRepository;

  FetchTranslationsForWords({required this.wordRepository});

  Future<Either<Failure, List<WordEntity>>> call(List<WordEntity> words) async {
    return await wordRepository.fetchTranslationsForWords(words);
  }
}
