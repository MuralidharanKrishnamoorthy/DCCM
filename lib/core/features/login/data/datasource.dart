import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl;

  AuthRepository({required this.baseUrl});

  Future<String> login(String email, String password, String deviceId) async {
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
      return responseData['token']; // Ensure your API returns a 'token'
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}
