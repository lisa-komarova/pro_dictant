import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/statistics_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateDayStatistics {
  final ProfileRepository profileRepository;

  UpdateDayStatistics({required this.profileRepository});

  Future<Either<Failure, StatisticsEntity>> call(DateTime date) async {
    return await profileRepository.updateDayStatistics(date);
  }
}
