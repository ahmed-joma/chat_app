import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> logInUser({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoadingState());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      emit(const LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailureState(errMessage: _loginErrorMessage(e.code)));
    } catch (_) {
      emit(const LoginFailureState(errMessage: 'Something went wrong.'));
    }
  }

  Future<void> signUpUser({
    required String email,
    required String password,
  }) async {
    emit(const RegisterLoadingState());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      emit(const RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(RegisterFailureState(errMessages: _registerErrorMessage(e.code)));
    } catch (_) {
      emit(const RegisterFailureState(errMessages: 'Something went wrong.'));
    }
  }

  String _loginErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'User not found. Check your email.';
      case 'wrong-password':
        return 'Password is wrong.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      case 'account-exists-with-different-credential':
        return 'Account exists with different sign-in method.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An unknown error occurred.';
    }
  }

  String _registerErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'operation-not-allowed':
        return 'Email/password sign-up is disabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An unknown error occurred.';
    }
  }
}
