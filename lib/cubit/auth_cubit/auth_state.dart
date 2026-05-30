part of 'auth_cubit.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class LoginLoadingState extends AuthState {
  const LoginLoadingState();
}

class LoginSuccessState extends AuthState {
  const LoginSuccessState();
}

class LoginFailureState extends AuthState {
  final String errMessage;
  const LoginFailureState({required this.errMessage});
}

class RegisterLoadingState extends AuthState {
  const RegisterLoadingState();
}

class RegisterSuccessState extends AuthState {
  const RegisterSuccessState();
}

class RegisterFailureState extends AuthState {
  final String errMessages;
  const RegisterFailureState({required this.errMessages});
}
