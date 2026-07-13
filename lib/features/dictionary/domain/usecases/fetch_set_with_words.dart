import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/set_repository.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/word_repository.dart';

class FetchSetWithWords {
  final SetRepository setRepository;

  FetchSetWithWords({required this.setRepository});

  Future<Either<Failure, SetEntity>> call(String setId) async {
    return await setRepository.fetchSetWithWords(setId);
  }
}
