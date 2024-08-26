import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getdeviceinfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    return androidDeviceInfo.id;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosdeviceinfo = await deviceInfoPlugin.iosInfo;
    return iosdeviceinfo.identifierForVendor;
  }
  return null;
}
