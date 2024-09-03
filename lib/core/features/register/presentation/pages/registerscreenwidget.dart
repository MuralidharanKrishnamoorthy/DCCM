import 'package:dccm/Colors.dart';
import 'package:dccm/core/presentation/dialogbox/policy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class terms_and_conditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

// ignore: camel_case_types
class registerbutton extends StatelessWidget {
  const registerbutton({super.key, required this.onSubmit});
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ElevatedButton(
          onPressed: () {
            onSubmit();
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
}

// ignore: camel_case_types
class roleselection extends StatelessWidget {
  const roleselection({super.key, this.selectedRole, required this.onChanged});
  final String? selectedRole;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        items: ["Company", "Project Developer"].map((role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(
              role,
              style: GoogleFonts.poppins(color: spruce),
            ),
          );
        }).toList(),
        onChanged: (value) {
          onChanged(value);
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
}

// ignore: camel_case_types
class registerform extends StatelessWidget {
  const registerform(
      {super.key,
      required this.formKey,
      required this.onChangedEmail,
      required this.onChangedPassword});

  final GlobalKey<FormState> formKey;

  final ValueChanged<String> onChangedEmail;
  final ValueChanged<String> onChangedPassword;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onChanged: (value) {
                onChangedEmail(value);
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter the password';
                  }
                  return null;
                },
                onChanged: (value) {
                  onChangedPassword(value);
                }),
          ),
        ],
      ),
    );
  }
}
