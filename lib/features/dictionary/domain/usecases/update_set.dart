import 'package:dartz/dartz.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/set_repository.dart';

import '../../../../core/error/failure.dart';
import '../entities/set_entity.dart';
import '../entities/word_entity.dart';

class UpdateSet {
  final SetRepository setRepository;

  UpdateSet({required this.setRepository});

  Future<Either<Failure, void>> call(SetEntity setEntity,
      List<WordEntity> toAdd, List<WordEntity> toDelete) async {
    return await setRepository.updateSet(setEntity, toAdd, toDelete);
  }
}
