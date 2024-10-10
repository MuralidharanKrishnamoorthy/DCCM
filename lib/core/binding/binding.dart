// import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';

// Future<String?> getdeviceinfo() async {
//   final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//   if (Platform.isAndroid) {
//     AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
//     return androidDeviceInfo.id;
//   } else if (Platform.isIOS) {
//     IosDeviceInfo iosdeviceinfo = await deviceInfoPlugin.iosInfo;
//     return iosdeviceinfo.identifierForVendor;
//   }
//   return null;
// }
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceBinding {
  static const String baseUrl = 'http://192.168.1.6:8080/api/dccm';
  static Future<String?> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return androidDeviceInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    }
    return null;
  }

  static Future<void> storeDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_id', deviceId);
  }

  static Future<String?> getStoredDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('device_id');
  }

  static Future<bool> checkDeviceBinding(String deviceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/check-device-binding'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'deviceId': deviceId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['isBound'];
    } else {
      throw Exception('Failed to check device binding');
    }
  }
}
