import 'package:dccm/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  var email = '';
  var password = '';
  final _formkey = GlobalKey<FormState>();
  checkvalide() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: spruce,
      appBar: _appbar(),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                color: parchment,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(60),
                  bottomLeft: Radius.circular(60),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 250, child: _loginimage()),
                  _loginform()
                ],
              )),
        ],
      ),
    );
  }

  Form _loginform() {
    return Form(
      key: _formkey,
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
              onChanged: (Value) {
                email = Value.toString();
              },
            ),
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
                if (value.toString().length <= 5) {
                  return ' password length must be atleast 6 characters ';
                } else {
                  return null;
                }
              },
              onChanged: (Value) {
                password = Value.toString();
              },
            ),
          ),
          SizedBox(
            width: 300,
            height: 70,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () {
                  checkvalide();
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

  Image _loginimage() => Image.asset('images/Login.png');

  PreferredSize _appbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: AppBar(
        backgroundColor: parchment,
      ),
    );
  }
}
