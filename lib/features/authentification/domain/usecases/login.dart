import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository authRepository;

  Login({required this.authRepository});

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
  }) async {
    return await authRepository.login(
      email: email,
      password: password,
    );
  }
}
