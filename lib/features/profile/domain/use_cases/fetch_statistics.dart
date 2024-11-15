import 'package:dartz/dartz.dart';
import 'package:pro_dictant/features/profile/domain/entities/statistics_entity.dart';

import '../../../../core/error/failure.dart';
import '../repositories/profile_repository.dart';

class FetchStatistics {
  final ProfileRepository profileRepository;

  FetchStatistics({required this.profileRepository});

  Future<Either<Failure, StatisticsEntity>> call() async {
    return await profileRepository.fetchStatistics();
  }
}
