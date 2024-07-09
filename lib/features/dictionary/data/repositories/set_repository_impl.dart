import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/data/datasources/word_local_datasource.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/set_repository.dart';

import '../../../../core/error/exception.dart';
import '../../domain/entities/set_entity.dart';

class SetRepositoryImpl extends SetRepository {
  final WordLocalDatasource localDataSource;

  SetRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SetEntity>>> loadSets() async {
    try {
      final sets = await localDataSource.fetchSets();
      return Right(sets);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
