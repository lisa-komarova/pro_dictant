import 'package:dartz/dartz.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';

import '../../../../core/error/failure.dart';
import '../repositories/word_repository.dart';

class AddWordsInSetToDictionary {
  final WordRepository wordRepository;

  AddWordsInSetToDictionary({required this.wordRepository});

  Future<Either<Failure, void>> call(List<TranslationEntity> words) async {
    return await wordRepository.addWordsInSetToDictionary(words);
  }
}
