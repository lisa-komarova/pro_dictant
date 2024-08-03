import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/word_repository.dart';

class SearchWordsForASet {
  final WordRepository wordRepository;

  SearchWordsForASet({required this.wordRepository});

  //TODO is this the right way to use call
  Future<Either<Failure, List<WordEntity>>> call(String query) async {
    return await wordRepository.searchWordForASet(query);
  }
}
