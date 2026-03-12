import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class SignupWithEmailAndPassword {
  final AuthRepository authRepository;

  SignupWithEmailAndPassword({required this.authRepository});

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
  }) async {
    return await authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
