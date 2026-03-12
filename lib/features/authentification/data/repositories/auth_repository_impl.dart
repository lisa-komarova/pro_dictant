import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) {
    return _handleAuthAction(() => remoteDataSource.login(
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failure, void>> signInWithGoogle() {
    return _handleAuthAction(() => remoteDataSource.signInWithGoogle());
  }

  @override
  Future<Either<Failure, void>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _handleAuthAction(() => remoteDataSource.signUpWithEmailAndPassword(
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await remoteDataSource.resetPassword(email: email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(code: e.toString()));
    }
  }

  Future<Either<Failure, void>> _handleAuthAction(
    Future<void> Function() action,
  ) async {
    try {
      await action();
      return Right(Future<void>);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(code: e.code));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return Left(AuthFailure(code: 'google-sign-in-cancelled'));
      } else {
        return Left(AuthFailure(code: 'google-sign-in-failed'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
