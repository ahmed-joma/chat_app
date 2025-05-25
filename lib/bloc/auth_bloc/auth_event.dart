part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

// ignore: must_be_immutable
class LoginEvent extends AuthEvent {
  String email;
  String password;
  LoginEvent({required this.email, required this.password});
}

// ignore: must_be_immutable
class RegisterEvent extends AuthEvent {
  String email;
  String password;
  RegisterEvent({required this.email, required this.password});
}
