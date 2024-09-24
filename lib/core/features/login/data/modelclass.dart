// ignore: camel_case_types

class Loginmodel {
  final String email;
  final String token;

  Loginmodel({required this.email, required this.token});
  factory Loginmodel.fromJson(Map<String, dynamic> json) {
    return Loginmodel(email: json['email'], token: json['token']);
  }
}
