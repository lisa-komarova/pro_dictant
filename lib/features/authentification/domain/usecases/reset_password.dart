import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository authRepository;

  ResetPassword({required this.authRepository});

  Future<Either<Failure, void>> call(String email) async {
    return await authRepository.resetPassword(email: email);
  }
}