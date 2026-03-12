import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<void> login({
    required String email,
    required String password,
  });
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signInWithGoogle();
  Future<void> resetPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });
  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'User is null after login',
      );
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user == null) {
      throw Exception('User is null');
    }

  }

  @override
  Future<void> signInWithGoogle() async {
    await googleSignIn.authenticate(
      scopeHint: ['email'],
    );
    final authClient = googleSignIn.authorizationClient;
    final authorization = await authClient.authorizationForScopes(['email']);

    final credential = GoogleAuthProvider.credential(
      accessToken: authorization?.accessToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCredential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'google-sign-in-cancelled',
      );
    }

  }

  @override
  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
