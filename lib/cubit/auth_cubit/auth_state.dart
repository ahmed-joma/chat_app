part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {}

// ignore: must_be_immutable
class LoginFailureState extends AuthState {
  String errMessage;
  LoginFailureState({required this.errMessage});
}

//----------

class RegisterLoadingState extends AuthState {}

class RegisterSuccessState extends AuthState {}

// ignore: must_be_immutable
class RegisterFailureState extends AuthState {
  String errMessages;
  RegisterFailureState({required this.errMessages});
}
