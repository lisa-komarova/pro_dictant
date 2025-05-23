import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/word_entity.dart';
import '../repositories/word_repository.dart';

class SearchTranslationOnline {
  final WordRepository wordRepository;

  SearchTranslationOnline({required this.wordRepository});

  Future<Either<Failure, List<WordEntity>>> call(String word) async {
    return await wordRepository.searchTranslationOnline(word);
  }
}
