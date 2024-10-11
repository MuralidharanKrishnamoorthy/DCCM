import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({Key? key}) : super(key: key);

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isLoading = false;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    [
      'Company Name',
      'Email',
      'Mobile No.',
      'Address',
      'Pincode',
      'State',
      'Country',
      'Company Register ID',
      'Carbon Emission Rate (tons)',
      'Emission Period'
    ].forEach((field) {
      _controllers[field] = TextEditingController();
    });
    _fetchCompanyProfile();
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _fetchCompanyProfile() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.6:8080/api/dccm/companyprofile'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _controllers.forEach((key, controller) {
          controller.text = data[key]?.toString() ?? '';
        });
      } else {
        print('Failed to fetch profile. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final url =
            Uri.parse('http://192.168.1.6:8080/api/dccm/companyprofile');
        final headers = {'Content-Type': 'application/json'};
        final body = json.encode({
          'companyname': _controllers['Company Name']!.text,
          'email': _controllers['Email']!.text,
          'mobilenumber': _controllers['Mobile No.']!.text,
          'address': _controllers['Address']!.text,
          'pincode': _controllers['Pincode']!.text,
          'state': _controllers['State']!.text,
          'country': _controllers['Country']!.text,
          'companyregid': _controllers['Company Register ID']!.text,
          'co2emissionrate': _controllers['Carbon Emission Rate (tons)']!.text,
          'emissionperiod': _controllers['Emission Period']!.text,
        });

        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
          setState(() => _isEditing = false);
        } else {
          print('Server responded with status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          throw Exception('Failed to update profile: ${response.body}');
        }
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: ${e.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        color: Colors.teal[700],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(Icons.person,
                                  color: Colors.teal[700], size: 40),
                            ),
                            const SizedBox(width: 15),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              padding: const EdgeInsets.all(20),
                              children: [
                                if (!_isEditing)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () =>
                                          setState(() => _isEditing = true),
                                      child: const Text('Edit',
                                          style: TextStyle(color: Colors.blue)),
                                    ),
                                  ),
                                ..._controllers.entries.map(
                                    (e) => _buildTextField(e.key, e.value)),
                                const SizedBox(height: 20),
                                if (_isEditing)
                                  ElevatedButton(
                                    onPressed: _saveChanges,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal[700],
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Update',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    ),
                                  ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _logout,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Logout',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.teal[700]!, width: 2),
          ),
        ),
        enabled: _isEditing,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  void _logout() {
    // Implement logout functionality
  }
}
