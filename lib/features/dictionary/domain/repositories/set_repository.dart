import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';

abstract class SetRepository {
  Future<Either<Failure, List<SetEntity>>> loadSets();
}
