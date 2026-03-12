import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GoogleSignIn {
  final AuthRepository authRepository;

  GoogleSignIn({required this.authRepository});

  Future<Either<Failure, UserEntity>> call() async {
    return await authRepository.signInWithGoogle();
  }
}
