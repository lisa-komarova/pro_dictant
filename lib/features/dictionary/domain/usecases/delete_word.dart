import 'package:dartz/dartz.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/word_repository.dart';

import '../../../../core/error/failure.dart';

class DeleteWord {
  final WordRepository wordRepository;

  DeleteWord({required this.wordRepository});

  Future<Either<Failure, void>> call(WordEntity wordEntity) async {
    return await wordRepository.deleteWord(wordEntity);
  }
}
