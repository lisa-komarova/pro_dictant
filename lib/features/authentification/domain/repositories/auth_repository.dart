import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> signInWithGoogle();
  Future<Either<Failure, void>> resetPassword({
    required String email,
  });
}
