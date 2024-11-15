import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/profile_repository.dart';

class GetTimeOnApp {
  final ProfileRepository profileRepository;

  GetTimeOnApp({required this.profileRepository});

  Future<Either<Failure, void>> call() async {
    return await profileRepository.getTimeOnApp();
  }
}
