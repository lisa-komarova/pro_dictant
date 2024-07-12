import 'package:dartz/dartz.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/word_repository.dart';

import '../../../../core/error/failure.dart';

class FetchWordBySource {
  final WordRepository wordRepository;

  FetchWordBySource({required this.wordRepository});

  Future<Either<Failure, List<WordEntity>>> call(String source) async {
    return await wordRepository.fetchWordBySource(source);
  }
}
