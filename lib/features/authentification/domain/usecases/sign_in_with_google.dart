import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository authRepository;

  SignInWithGoogle({required this.authRepository});

  Future<Either<Failure, void>> call() async {
    return await authRepository.signInWithGoogle();
  }
}
