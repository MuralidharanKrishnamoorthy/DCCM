import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl;

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
}

class LoginModel {
  final String email;
  final String token;

  LoginModel({required this.email, required this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(email: json['email'], token: json['token']);
  }
}
