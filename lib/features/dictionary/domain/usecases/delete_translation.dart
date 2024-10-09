import 'package:dartz/dartz.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/word_repository.dart';

import '../../../../core/error/failure.dart';

class DeleteTranslation {
  final WordRepository wordRepository;

  DeleteTranslation({required this.wordRepository});

  Future<Either<Failure, void>> call(
      TranslationEntity translationEntity) async {
    return await wordRepository.deleteTranslation(translationEntity);
  }
}
