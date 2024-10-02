import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dccm/core/features/login/data/datasource.dart'
    as login_datasource;
import 'package:jwt_decoder/jwt_decoder.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final login_datasource.AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      emit(LoginInitial());
    });

    on<loginbuttonclickedevent>((event, emit) async {
      final emailvalidate = validateemail(event.emailvalidate);
      final passwordvalidate = validatepassword(event.passwordvalidate);
      if (emailvalidate != null || passwordvalidate != null) {
        emit(loginfailedstate(
            emailvalidate: emailvalidate, passwordvalidate: passwordvalidate));
        return;
      }
      try {
        final token = await authRepository.login(
          event.emailvalidate,
          event.passwordvalidate,
          event.deviceId,
        );
        final decodedToken = JwtDecoder.decode(token);
        final role = decodedToken['role'] as String?;
        if (role == null ||
            (role != 'Company' && role != 'Project Developer')) {
          throw Exception('Invalid or missing role in token');
        }
        emit(loginsuccessstate(token: token, role: role));
      } catch (e) {
        emit(loginfailedstate(
          emailvalidate: 'Login failed',
          passwordvalidate: e.toString(),
        ));
      }
    });
  }
}

String? validateemail(String emailvalidate) {
  if (emailvalidate.isEmpty) {
    return 'Enter the Email';
  }
  return null;
}

String? validatepassword(String passwordvalidate) {
  if (passwordvalidate.isEmpty) {
    return 'Enter your password';
  } else if (passwordvalidate.length < 8) {
    return 'password length must be atleast 8';
  }
  return null;
}
