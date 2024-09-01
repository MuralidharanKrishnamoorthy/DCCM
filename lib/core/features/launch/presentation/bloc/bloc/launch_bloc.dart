import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'launch_event.dart';
part 'launch_state.dart';

class LaunchBloc extends Bloc<LaunchEvent, LaunchState> {
  LaunchBloc() : super(LaunchInitial()) {
    on<Launchinitialevent>((event, emit) {
      emit(Launchinitialstate());
    });
    on<Getstartclickededevent>(
      (event, emit) async {
        emit(Getstartedloadingstate());
        await Future.delayed(const Duration(seconds: 5));
        emit(Getstartedloadedstate());
      },
    );
  }
}
