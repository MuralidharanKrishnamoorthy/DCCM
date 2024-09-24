// ignore_for_file: camel_case_types

part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class logininitialevent extends LoginEvent {}

class loginbuttonclickedevent extends LoginEvent {
  final String emailvalidate;
  final String passwordvalidate;
  final String deviceId;

  const loginbuttonclickedevent(
      {required this.emailvalidate,
      required this.passwordvalidate,
      required this.deviceId});

  @override
  List<Object> get props => [emailvalidate, passwordvalidate, deviceId];
}

class loginvalidateevent extends LoginEvent {}

class loginsuccessevent extends LoginEvent {}

class loginfailureevent extends LoginEvent {}
