import 'package:bloc/bloc.dart';
import 'package:dccm/core/binding/binding.dart';
import 'package:equatable/equatable.dart';

part 'devicebinding_event.dart';
part 'devicebinding_state.dart';

class DevicebindingBloc extends Bloc<DevicebindingEvent, DevicebindingState> {
  DevicebindingBloc() : super(DeviceBindingInitial()) {
    on<Devicebindingcheckevent>(_onCheckDeviceBinding);
  }
  Future<void> _onCheckDeviceBinding(
    Devicebindingcheckevent event,
    Emitter<DevicebindingState> emit,
  ) async {
    emit(DeviceBindingLoading());
    try {
      String? deviceId = await DeviceBinding.getDeviceInfo();
      if (deviceId != null) {
        await DeviceBinding.storeDeviceId(deviceId);
        bool isBound = await DeviceBinding.checkDeviceBinding(deviceId);
        emit(DeviceBindingComplete(isBound));
      } else {
        emit(const DeviceBindingError('Failed to get device ID'));
      }
    } catch (e) {
      emit(DeviceBindingError(e.toString()));
    }
  }
}
