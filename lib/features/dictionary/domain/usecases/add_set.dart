import 'package:dartz/dartz.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/set_repository.dart';

import '../../../../core/error/failure.dart';

class AddSet {
  final SetRepository setRepository;

  AddSet({required this.setRepository});

  Future<Either<Failure, void>> call(SetEntity setEntity) async {
    return await setRepository.addSet(setEntity);
  }
}
