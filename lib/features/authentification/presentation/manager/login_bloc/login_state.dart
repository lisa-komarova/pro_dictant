import '../../../../../core/error/failure.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final Failure failure;

  LoginFailure(this.failure);
}
