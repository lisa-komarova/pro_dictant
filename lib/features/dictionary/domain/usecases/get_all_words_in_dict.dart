import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/word_repository.dart';

class GetAllWordsInDict {
  final WordRepository wordRepository;

  GetAllWordsInDict({required this.wordRepository});

  Future<Either<Failure, List<WordEntity>>> call() async {
    return await wordRepository.getAllWordsInDict();
  }
}
