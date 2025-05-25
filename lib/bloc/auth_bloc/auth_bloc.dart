import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>(
      (event, emit) async {
        if (event is LoginEvent) {
          emit(LoginLoadingState());
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: event.email, password: event.password);
            emit(LoginSuccessState());
          } on FirebaseAuthException catch (e) {
            // Print error code for debugging
            print('Firebase Error Code: ${e.code}');
            if (e.code == 'user-not-found') {
              emit(LoginFailureState(
                  errMessage: 'User not found. Check your email.'));
            } else if (e.code == 'wrong-password') {
              emit(LoginFailureState(errMessage: 'Password is wrong.'));
            } else if (e.code == 'invalid-email') {
              emit(LoginFailureState(errMessage: 'Invalid email format.'));
            } else if (e.code == 'user-disabled') {
              emit(LoginFailureState(
                  errMessage: 'This user has been disabled.'));
            } else if (e.code == 'too-many-requests') {
              emit(LoginFailureState(
                  errMessage: 'Too many attempts. Try again later.'));
            } else if (e.code == 'operation-not-allowed') {
              emit(LoginFailureState(
                  errMessage:
                      'Operation not allowed. Please contact support.'));
            } else if (e.code == 'invalid-credential') {
              emit(LoginFailureState(
                  errMessage:
                      'Invalid credentials. Please check your email and password.'));
            } else if (e.code == 'account-exists-with-different-credential') {
              emit(LoginFailureState(
                  errMessage: 'Account exists with different sign-in method.'));
            } else if (e.code == 'network-request-failed') {
              emit(LoginFailureState(
                  errMessage: 'Network error. Please check your connection.'));
            } else if (e.code == 'expired-action-code') {
              emit(LoginFailureState(
                  errMessage: 'The action code has expired.'));
            } else if (e.code == 'invalid-action-code') {
              emit(
                  LoginFailureState(errMessage: 'The action code is invalid.'));
            } else if (e.code == 'weak-password') {
              emit(LoginFailureState(errMessage: 'The password is too weak.'));
            } else {
              emit(LoginFailureState(
                  errMessage: e.message ?? 'An unknown error occurred.'));
            }
          } catch (e) {
            emit(LoginFailureState(errMessage: 'Something went wrong.'));
          }
        } else if (event is RegisterEvent) {
          emit(RegisterLoadingState());
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: event.email, password: event.password);
            emit(RegisterSuccessState());
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              emit(RegisterFailureState(errMessages: 'passport is weak'));
            } else if (e.code == 'email-already-in-use') {
              emit(RegisterFailureState(errMessages: 'email already in use'));
            }
          } catch (e) {
            emit(RegisterFailureState(errMessages: 'there is wrong'));
          }
        }
      },
    );
  }
}
