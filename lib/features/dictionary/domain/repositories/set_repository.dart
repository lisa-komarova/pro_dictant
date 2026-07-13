import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';

import '../entities/set_card_info_entity.dart';
import '../entities/word_entity.dart';

abstract class SetRepository {
  Future<Either<Failure, List<SetCardInfoEntity>>> loadSets();

  Future<Either<Failure, void>> addSet(SetEntity set);

  Future<Either<Failure, void>> updateSet(
      SetEntity set, List<WordEntity> toAdd, List<WordEntity> toDelete);

  Future<Either<Failure, void>> deleteSet(String setId);

  Future<Either<Failure, SetEntity>> fetchSetWithWords(
      String setId);
}
