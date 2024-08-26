part of 'projectdetails_bloc.dart';

sealed class ProjectdetailsState extends Equatable {
  const ProjectdetailsState();
  
  @override
  List<Object> get props => [];
}

final class ProjectdetailsInitial extends ProjectdetailsState {}
