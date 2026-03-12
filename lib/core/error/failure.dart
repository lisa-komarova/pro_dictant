import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'server_error']) : super(message);
}

class AuthFailure extends Failure {
  final String code;

  const AuthFailure({
    required this.code,
    String message = 'auth_error',
  }) : super(message);

  @override
  List<Object?> get props => [message, code];
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'cache_error']) : super(message);
}
