import 'package:dartz/dartz.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/set_repository.dart';

import '../../../../core/error/failure.dart';

class DeleteSet {
  final SetRepository setRepository;

  DeleteSet({required this.setRepository});

  Future<Either<Failure, void>> call(String setId) async {
    return await setRepository.deleteSet(setId);
  }
}
