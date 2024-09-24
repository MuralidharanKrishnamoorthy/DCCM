// ignore_for_file: camel_case_types

part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

class loginvalidatestate extends LoginState {}

class loginsuccessstate extends LoginState {
  final String token;
  final String role;

  loginsuccessstate({required this.token, required this.role});
  @override
  List<Object> get props => [token, role];
}

class loginfailedstate extends LoginState {
  final String? emailvalidate;
  final String? passwordvalidate;

  const loginfailedstate(
      {required this.emailvalidate, required this.passwordvalidate});

  @override
  List<Object> get props => [emailvalidate ?? '', passwordvalidate ?? ''];
}
