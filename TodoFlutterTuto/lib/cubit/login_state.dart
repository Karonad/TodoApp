part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});
}

class LoggingIn extends LoginState {}

class LoggedIn extends LoginState {}
