part of 'launch_bloc.dart';

sealed class LaunchEvent extends Equatable {
  const LaunchEvent();

  @override
  List<Object> get props => [];
}

class Launchinitialevent extends LaunchEvent {}

class Getstartclickededevent extends LaunchEvent {}

class Getstartedloadedevent extends LaunchEvent {}
