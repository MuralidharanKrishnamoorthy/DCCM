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

  const Regbuttonclickedevent(this.email, this.password, this.selectedRole);
  @override
  List<Object?> get props => [email, password, selectedRole];
}
