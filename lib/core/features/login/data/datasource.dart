import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String baseUrl;
  // ignore: non_constant_identifier_names
  static String DEVICE_ID_KEY = 'device_id';
  static const String AUTH_TOKEN_KEY = 'auth-token';

  AuthRepository({required this.baseUrl});

  Future<String> login(String email, String password, String deviceId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': email.trim(),
          'Password': password,
          'deviceId': deviceId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['token'];
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AUTH_TOKEN_KEY, data['token']);
    await prefs.setString('role', data['role']);
    await prefs.setString(DEVICE_ID_KEY, data['deviceId']);
  }

  Future<String?> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(DEVICE_ID_KEY);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AUTH_TOKEN_KEY);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AUTH_TOKEN_KEY);
    await prefs.remove('role');
    // Don't remove the device ID as it's bound to the device
  }
}

// class LoginModel {
//   final String email;
//   final String token;

//   LoginModel({required this.email, required this.token});

//   factory LoginModel.fromJson(Map<String, dynamic> json) {
//     return LoginModel(email: json['email'], token: json['token']);
//   }
// }
