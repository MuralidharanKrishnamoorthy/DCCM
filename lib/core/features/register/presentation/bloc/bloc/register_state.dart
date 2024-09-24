part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  final String email;
  final String password;
  final String? selectedRole;

  const RegisterInitial(
      {this.email = '', this.password = '', this.selectedRole});

  @override
  List<Object?> get props => [email, password, selectedRole];
}

class Regloadingstate extends RegisterState {}

class Regsuccessstate extends RegisterState {
  final String token;

  const Regsuccessstate({required this.token});
  @override
  List<Object?> get props => [token];
}

class Regfailedstate extends RegisterState {
  final String? emailcheck;
  final String? passwordcheck;
  final String? selectedrolecheck;

  const Regfailedstate(
      this.emailcheck, this.passwordcheck, this.selectedrolecheck);
  @override
  List<Object?> get props => [emailcheck, passwordcheck, selectedrolecheck];
}
