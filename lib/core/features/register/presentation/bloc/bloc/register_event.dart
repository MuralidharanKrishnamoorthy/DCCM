part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class Registerinitialevent extends RegisterEvent {}

class Regbuttonclickedevent extends RegisterEvent {
  final String email;
  final String password;
  final String? selectedRole;
  final String? deviceId;

  const Regbuttonclickedevent(
      this.email, this.password, this.selectedRole, this.deviceId);
  @override
  List<Object?> get props => [email, password, selectedRole, deviceId];
}
