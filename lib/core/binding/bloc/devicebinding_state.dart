part of 'devicebinding_bloc.dart';

sealed class DevicebindingState extends Equatable {
  const DevicebindingState();

  @override
  List<Object> get props => [];
}

class DeviceBindingInitial extends DevicebindingState {}

class DeviceBindingLoading extends DevicebindingState {}

class DeviceBindingComplete extends DevicebindingState {
  final bool isBound;
  const DeviceBindingComplete(this.isBound);

  @override
  List<Object> get props => [isBound];
}

class DeviceBindingError extends DevicebindingState {
  final String error;
  const DeviceBindingError(this.error);

  @override
  List<Object> get props => [error];
}
