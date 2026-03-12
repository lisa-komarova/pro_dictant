import 'package:flutter/material.dart';
import '../../core/error/failure.dart';
import '../s.dart';

class ErrorMapper {
  static String mapFailureToMessage(BuildContext context, Failure failure) {

    if (failure is AuthFailure) {
      switch (failure.code) {
        case 'user-not-found':
          return S.of(context).errorUserNotFound;
        case 'wrong-password':
          return S.of(context).errorWrongPassword;
        case 'email-already-in-use':
          return S.of(context).errorEmailAlreadyInUse;
        case 'invalid-email':
          return S.of(context).errorInvalidEmail;
        case 'weak-password':
          return S.of(context).errorWeakPassword;
        case 'user-disabled':
          return S.of(context).errorUserDisabled;
        case 'operation-not-allowed':
          return S.of(context).errorOperationNotAllowed;
        case 'too-many-requests':
          return S.of(context).errorTooManyRequests;
        case 'network-request-failed':
          return S.of(context).errorNetworkRequestFailed;
        case 'google-sign-in-cancelled':
          return S.of(context).errorGoogleCancelled;
        default:
          return S.of(context).errorInternalAuth + '(${failure.code})';
      }
    }

    if (failure is ServerFailure) {
      return S.of(context).errorServer;
    }

    return S.of(context).errorUnknown;
  }
}
