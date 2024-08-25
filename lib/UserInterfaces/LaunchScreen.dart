import 'package:dccm/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _GradientColor(context),
        _launchimage(),
        WelcomeText(),
        ThemeText(),
        Padding(
          padding: const EdgeInsets.only(top: 650, left: 30),
          child: SizedBox(
            height: 50,
            width: 300,
            child: _RegisterButton(context),
          ),
        ),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Container _GradientColor(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          spruce.withOpacity(0.85),
          spruce.withOpacity(0.6),
          linen.withOpacity(0.4),
        ], stops: const [
          0.1,
          0.5,
          1.0
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ElevatedButton _RegisterButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, '/Registerscreen');
      },
      icon: Icon(
        Icons.emoji_nature,
        color: linen,
      ),
      label: Text(
        'Get started',
        style: GoogleFonts.poppins(fontSize: 18, color: linen),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: spruce,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    );
  }

  // ignore: non_constant_identifier_names
  Padding ThemeText() {
    return Padding(
        padding: const EdgeInsets.only(top: 530, left: 30, right: 5),
        child: Text(
            'Your one-stop solution for decentralized carbon credit management',
            style: GoogleFonts.poppins(
                color: spruce, fontWeight: FontWeight.bold, fontSize: 24)));
  }

  // ignore: non_constant_identifier_names
  Padding WelcomeText() {
    return Padding(
        padding: const EdgeInsets.only(top: 490, left: 30),
        child: Text('Welcome to DCCM',
            style: GoogleFonts.poppins(
                color: spruce, fontWeight: FontWeight.bold, fontSize: 24)));
  }

  Padding _launchimage() {
    return Padding(
        padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
        child: SizedBox(
            height: 400,
            width: 350,
            child: Image.asset('images/launchscreen.png')));
  }
}
