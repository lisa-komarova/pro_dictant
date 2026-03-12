abstract class LoginEvent {}

class SignupWithEmailAndPassword extends LoginEvent {
  final String email;
  final String password;

  SignupWithEmailAndPassword({
    required this.email,
    required this.password,
  });
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({
    required this.email,
    required this.password,
  });
}
class GoogleSignInPressed extends LoginEvent {}

class ForgotPasswordPressed extends LoginEvent {
  final String email;

  ForgotPasswordPressed(this.email);
}