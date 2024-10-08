import 'package:dccm/core/presentation/dialogbox/policy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../Colors.dart';

class loginform extends StatelessWidget {
  const loginform(
      {super.key,
      required this.formKey,
      required this.email,
      required this.password,
      required this.onChangedEmail,
      required this.onChangedPassword,
      required this.onSubmit});
  final GlobalKey<FormState> formKey;
  final String email;
  final String password;
  final ValueChanged<String> onChangedEmail;
  final ValueChanged<String> onChangedPassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      size: 20,
                    ),
                    hintText: 'Enter your Email',
                    hintStyle: GoogleFonts.poppins(color: spruce, fontSize: 15),
                    labelStyle: GoogleFonts.poppins(color: spruce),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: spruce, width: 2))),
                key: const ValueKey('email'),
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Email is required';
                  } else {
                    return null;
                  }
                },
                onChanged: onChangedEmail),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 5),
            child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 20,
                    ),
                    hintText: 'Enter your Password',
                    hintStyle: GoogleFonts.poppins(color: spruce, fontSize: 15),
                    labelStyle: GoogleFonts.poppins(color: spruce),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: spruce, width: 2))),
                key: const ValueKey('password'),
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Enter your password'; // Ensure this matches BLoC logic
                  } else if (value!.length < 8) {
                    return 'Password length must be at least 8';
                  }
                  return null;
                },
                onChanged: onChangedPassword),
          ),
          SizedBox(
            width: 300,
            height: 70,
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () {
                  onSubmit();
                  //  Navigator.pushNamed(context, '/Login');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: spruce,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(color: linen),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
