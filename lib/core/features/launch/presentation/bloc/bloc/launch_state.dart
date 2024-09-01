part of 'launch_bloc.dart';

sealed class LaunchState extends Equatable {
  const LaunchState();

  @override
  List<Object> get props => [];
}

final class LaunchInitial extends LaunchState {}

class Launchinitialstate extends LaunchState {}

class Getstartedloadingstate extends LaunchState {}

class Getstartedloadedstate extends LaunchState {}
