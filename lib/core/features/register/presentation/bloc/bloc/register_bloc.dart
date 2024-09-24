// ignore_for_file: prefer_const_constructors

import 'package:bloc/bloc.dart';
import 'package:dccm/core/features/register/data/datasource.dart';

import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  RegisterBloc(this.authRepository) : super(RegisterInitial()) {
    on<Registerinitialevent>((event, emit) {
      emit(RegisterInitial());
    });
    on<Regbuttonclickedevent>((event, emit) async {
      emit(Regloadingstate());
      await Future.delayed(const Duration(seconds: 3));
      final emailcheck = validateemail(event.email);
      final passwordcheck = validatepassword(event.password);
      final selectedrolecheck = validaterole(event.selectedRole);
      if (emailcheck != null ||
          passwordcheck != null ||
          selectedrolecheck != null) {
        emit(Regfailedstate(emailcheck, passwordcheck, selectedrolecheck));
        print("failed is emitting");
      } else {
        try {
          final token = await authRepository.register(event.email,
              event.password, event.selectedRole!, event.deviceId!);
          emit(Regsuccessstate(token: token));
        } catch (error) {
          emit(Regfailedstate("Registration failed: $error", null, null));

          print("Success is emmitting");
        }
      }
    });
  }
}

String? validateemail(String email) {
  if (email.isEmpty) {
    return 'Please enter your email';
  }
  return null;
}

String? validatepassword(String password) {
  if (password.length < 6) {
    return 'Password length must be atleast 7 characters';
  }
  return null;
}

String? validaterole(String? selectedRole) {
  if (selectedRole == null || selectedRole.isEmpty) {
    return 'This field is mandatory';
  }
  return null;
}
