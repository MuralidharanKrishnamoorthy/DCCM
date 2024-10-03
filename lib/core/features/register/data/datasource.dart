import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl = 'http://192.168.137.117:8080/api/dccm';

  Future<String> register(String email, String password, String selectedRole,
      String deviceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Email': email,
        'Password': password,
        'Role': selectedRole,
        'deviceId': deviceId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['token'];
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }
}
