import 'package:dccm/core/utils/Company/CompanyNavigation.dart';
import 'package:dccm/customappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dccm/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isLoading = false;
  final Map<String, TextEditingController> _controllers = {};
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    for (var field in [
      'companyname',
      'email',
      'mobilenumber',
      'address',
      'pincode',
      'state',
      'country',
      'companyregid',
      'co2emissionrate',
      'emissionperiod'
    ]) {
      _controllers[field] = TextEditingController();
    }
    _loadUserEmail().then((_) => _fetchCompanyProfile());
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('email');
    });
  }

  Future<void> _fetchCompanyProfile() async {
    if (_userEmail == null) {
      _showErrorDialog('User email not found. Please log in again.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.122.19:8080/api/dccm/companyprofile/$_userEmail'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _controllers.forEach((key, controller) {
            controller.text = data[key]?.toString() ?? '';
          });
        });
      } else if (response.statusCode == 404) {
        setState(() => _isEditing = true);
      } else {
        throw Exception('Failed to load company profile');
      }
    } catch (e) {
      _showErrorDialog('Failed to load company profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await http.post(
          Uri.parse('http://192.168.122.19:8080/api/dccm/companyprofile'),
          body: json.encode(
              _controllers.map((key, value) => MapEntry(key, value.text))),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();
          String emissionRate = _controllers['co2emissionrate']!.text;

          await prefs.setString('co2_emission_rate', emissionRate);
          print('Saved CO2 emission rate: $emissionRate');

          _showSuccessDialog('Profile updated successfully');
          setState(() => _isEditing = false);
        } else {
          throw Exception('Failed to update profile');
        }
      } catch (e) {
        _showErrorDialog('Failed to update profile: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: kParchment,
      navigationBar: CustomAppbar(
        leading: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CompanyNavigation()),
          ),
          child: CircleAvatar(
            backgroundColor: AppTheme.getTertiaryIconColor(context),
            child: Icon(
              CupertinoIcons.back,
              color: AppTheme.getAppBarForegroundColor(context),
              size: 20, // Adjust size as needed
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildHeader(),
                  ),
                  SliverToBoxAdapter(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            _buildSectionHeader('Company Information'),
                            _buildInfoCard([
                              _buildTextField(
                                  'Company Name', _controllers['companyname']!),
                              _buildTextField('Email', _controllers['email']!),
                              _buildTextField(
                                  'Mobile No.', _controllers['mobilenumber']!),
                              _buildTextField('Company Registration ID',
                                  _controllers['companyregid']!),
                              _buildTextField('CO2 Emission Rate',
                                  _controllers['co2emissionrate']!),
                              _buildTextField('Emission Period',
                                  _controllers['emissionperiod']!),
                            ]),
                            _buildSectionHeader('Address'),
                            _buildInfoCard([
                              _buildTextField(
                                  'Address', _controllers['address']!),
                              _buildTextField(
                                  'Pincode', _controllers['pincode']!),
                              _buildTextField('State', _controllers['state']!),
                              _buildTextField(
                                  'Country', _controllers['country']!),
                            ]),
                            const SizedBox(height: 20),
                            _buildSaveButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoButton(
                          color: AppTheme.getErrorColor(context),
                          borderRadius: BorderRadius.circular(12),
                          onPressed: _logout,
                          child: const Text('Logout'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        // Background with glass effect
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kDeepBlue.withOpacity(0.7),
                    kVibrantBlue.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Decorative circles
        Positioned(
          top: -50,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -30,
          right: -30,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: CupertinoColors.white, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: CupertinoColors.systemGrey5,
                  child: Icon(CupertinoIcons.building_2_fill,
                      size: 60, color: CupertinoColors.systemGrey),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _controllers['companyname']?.text ?? 'Company Name',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white),
              ),
              const SizedBox(height: 8),
              Text(
                _controllers['email']?.text ?? 'Email Address',
                style:
                    const TextStyle(fontSize: 16, color: CupertinoColors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: controller,
            placeholder: 'Enter $label',
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: CupertinoColors.extraLightBackgroundGray,
              borderRadius: BorderRadius.circular(8),
            ),
            enabled: _isEditing,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return CupertinoButton(
      color: _isEditing
          ? AppTheme.getPrimaryButtonColor(context)
          : AppTheme.getSecondaryButtonColor(context),
      onPressed: _isEditing
          ? _saveChanges
          : () {
              setState(() => _isEditing = true);
            },
      borderRadius: BorderRadius.circular(12),
      child: Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
    );
  }

  void _logout() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('email');
    // Navigator.of(context).pushReplacementNamed('/login');
  }
}
