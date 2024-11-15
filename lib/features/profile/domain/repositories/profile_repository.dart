import 'package:dartz/dartz.dart';
import 'package:pro_dictant/features/profile/domain/entities/statistics_entity.dart';

import '../../../../core/error/failure.dart';

abstract class ProfileRepository {
  Future<Either<Failure, StatisticsEntity>> fetchStatistics();

  Future<Either<Failure, StatisticsEntity>> updateDayStatistics(DateTime date);

  Future<Either<Failure, StatisticsEntity>> updateGoal(int goalInMinutes);

  Future<Either<Failure, int>> getTimeOnApp();
}
