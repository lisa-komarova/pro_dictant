import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/word_entity.dart';
import '../repositories/word_repository.dart';

class GetLearningWordsInDict {
  final WordRepository wordRepository;

  GetLearningWordsInDict({required this.wordRepository});

  Future<Either<Failure, List<WordEntity>>> call() async {
    return await wordRepository.getLearningWords();
  }
}
