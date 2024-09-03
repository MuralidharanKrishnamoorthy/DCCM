import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      emit(LoginInitial());
    });
    on<loginbuttonclickedevent>(
      (event, emit) {
        final emailvalidate = validateemail(event.emailvalidate);
        final passwordvalidate = validatepassword(event.passwordvalidate);
        if (emailvalidate != null || passwordvalidate != null) {
          emit(loginfailedstate(
              emailvalidate: emailvalidate,
              passwordvalidate: passwordvalidate));
        } else {
          emit(loginsuccessstate());
        }
      },
    );
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
