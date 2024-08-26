import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'projectdetails_event.dart';
part 'projectdetails_state.dart';

class ProjectdetailsBloc extends Bloc<ProjectdetailsEvent, ProjectdetailsState> {
  ProjectdetailsBloc() : super(ProjectdetailsInitial()) {
    on<ProjectdetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
