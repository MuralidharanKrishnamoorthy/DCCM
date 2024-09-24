class Registermodel {
  final String email;
  final String password;
  final String selectedRole;
  final String? deviceId;

  Registermodel(
      {required this.email,
      required this.password,
      required this.selectedRole,
      required this.deviceId});

  Map<String, dynamic> tojson() {
    return {
      'Email': email,
      'Password': password,
      'Role': selectedRole,
      'deviceId': deviceId
    };
  }
}
