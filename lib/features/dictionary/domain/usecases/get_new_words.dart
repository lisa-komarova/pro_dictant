import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/word_entity.dart';
import '../repositories/word_repository.dart';

class GetNewWordsInDict {
  final WordRepository wordRepository;

  GetNewWordsInDict({required this.wordRepository});

  Future<Either<Failure, List<WordEntity>>> call() async {
    return await wordRepository.getNewWords();
  }
}
