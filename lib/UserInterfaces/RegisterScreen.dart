// ignore_for_file: non_constant_identifier_names

import 'package:dccm/dialogs/policy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dccm/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  var email = '';
  var password = '';
  final _formKey = GlobalKey<FormState>();

  checkvalide() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  String? selectedRole;
  final List<String> roles = ["Company", "Project Developer"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbar(),
      body: Stack(
        children: [
          Container(
            color: spruce,
          ),
          Container(
            width: double.infinity,
            height: 570,
            decoration: BoxDecoration(
              color: parchment,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SizedBox(
                    width: constraints.maxWidth * 0.8,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: _registerimage(),
                        ),
                        _registerform(),
                        _roleselection(),
                        _registerbutton(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _terms_and_conditions(context),
        ],
      ),
    );
  }

  Positioned _terms_and_conditions(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "By creating an account, you agree to our\n",
            style: GoogleFonts.poppins(color: linen, fontSize: 14.7),
            children: [
              TextSpan(
                text: "Terms of Service",
                style: GoogleFonts.poppins(
                  color: linen,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const PolicyDialog(
                          radius: 8,
                          mdfilename: 'terms_conditions.md',
                        );
                      },
                    );
                  },
              ),
              TextSpan(
                text: " and ",
                style: GoogleFonts.poppins(color: linen),
              ),
              TextSpan(
                text: "Privacy Policy",
                style: GoogleFonts.poppins(
                  color: linen,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const PolicyDialog(
                          radius: 8,
                          mdfilename: 'privacy_policy.md',
                        );
                      },
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _registerbutton() {
    return SizedBox(
      width: 300,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ElevatedButton(
          onPressed: () {
            checkvalide();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: spruce,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Text(
            'Register',
            style: GoogleFonts.poppins(color: linen),
          ),
        ),
      ),
    );
  }

  Padding _roleselection() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        items: roles.map((role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(
              role,
              style: GoogleFonts.poppins(color: spruce),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRole = value;
          });
        },
        decoration: InputDecoration(
          labelText: "Role",
          labelStyle: GoogleFonts.poppins(
            color: spruce,
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            Icons.person_outline,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: forest, width: 2),
          ),
        ),
        hint: Text(
          "Select your role",
          style: GoogleFonts.poppins(color: spruce),
        ),
      ),
    );
  }

  Form _registerform() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.poppins(color: spruce),
                hintText: "Enter your Email",
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  size: 20,
                ),
                hintStyle: GoogleFonts.poppins(
                  color: spruce,
                  fontSize: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: spruce, width: 2),
                ),
              ),
              key: const ValueKey('email'),
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Email cannot be empty";
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                email = value.toString();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: GoogleFonts.poppins(
                  color: spruce,
                  fontSize: 15,
                ),
                hintText: "Enter your Password",
                prefixIcon: const Icon(
                  Icons.lock,
                  size: 20,
                ),
                hintStyle: GoogleFonts.poppins(
                  color: spruce,
                  fontSize: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: spruce, width: 2),
                ),
              ),
              key: const ValueKey('password'),
              validator: (value) {
                if (value.toString().length <= 5) {
                  return "Password must be at least 6 characters";
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                password = value.toString();
              },
            ),
          ),
        ],
      ),
    );
  }

  Image _registerimage() {
    return Image.asset(
      'images/Registerscreen.png',
      width: 250,
    );
  }

  PreferredSize _appbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: AppBar(
        backgroundColor: parchment,
      ),
    );
  }
}
