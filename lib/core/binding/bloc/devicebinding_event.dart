part of 'devicebinding_bloc.dart';

sealed class DevicebindingEvent extends Equatable {
  const DevicebindingEvent();

  @override
  List<Object> get props => [];
}

class Devicebindingcheckevent extends DevicebindingEvent {}
