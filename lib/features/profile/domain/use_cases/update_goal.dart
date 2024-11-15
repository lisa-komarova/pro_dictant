import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/statistics_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateGoal {
  final ProfileRepository profileRepository;

  UpdateGoal({required this.profileRepository});

  Future<Either<Failure, StatisticsEntity>> call(int goalInMinutes) async {
    return await profileRepository.updateGoal(goalInMinutes);
  }
}
