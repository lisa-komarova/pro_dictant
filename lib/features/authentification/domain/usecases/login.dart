import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await authRepository.login(
      email: email,
      password: password,
    );
  }
}
