import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/authentification/domain/usecases/login.dart';
import 'package:pro_dictant/features/authentification/domain/usecases/reset_password.dart';
import '../../../domain/usecases/sign_in_with_google.dart';
import '../../../domain/usecases/signup_with_email_and_password.dart'
    as usecase;
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final SignInWithGoogle googleSignIn;
  final usecase.SignupWithEmailAndPassword signUpWithEmailAndPassword;
  final ResetPassword resetPassword;

  LoginBloc(
      {required this.login,
      required this.googleSignIn,
      required this.signUpWithEmailAndPassword,
      required this.resetPassword})
      : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<GoogleSignInPressed>(_onGoogleSignIn);
    on<SignupWithEmailAndPassword>(_onSignUpWithEmailAndPassword);
    on<ForgotPasswordPressed>(_onForgotPasswordPressed);
  }

  Future<void> _onSignUpWithEmailAndPassword(
    SignupWithEmailAndPassword event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await signUpWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (user) => emit(LoginSuccess()),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await login(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (user) => emit(LoginSuccess()),
    );
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await googleSignIn();
    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (user) => emit(LoginSuccess()),
    );
  }

  Future<void> _onForgotPasswordPressed(
    ForgotPasswordPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await resetPassword(event.email);
    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (_) {},
    );
  }
}
