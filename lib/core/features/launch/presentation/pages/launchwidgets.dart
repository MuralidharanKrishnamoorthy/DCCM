import 'package:dccm/Colors.dart';
import 'package:dccm/core/features/launch/presentation/bloc/bloc/launch_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class gradientcolor extends StatelessWidget {
  const gradientcolor({super.key});

  @override
  Widget build(BuildContext context) {
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
}

class Registerbutton extends StatelessWidget {
  const Registerbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read<LaunchBloc>().add(Getstartclickededevent());
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
}

// ignore: camel_case_types
class themetext extends StatelessWidget {
  const themetext({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 530, left: 30, right: 5),
        child: Text(
            'Your one-stop solution for decentralized carbon credit management',
            style: GoogleFonts.poppins(
                color: spruce, fontWeight: FontWeight.bold, fontSize: 24)));
  }
}

// ignore: camel_case_types
class welcometext extends StatelessWidget {
  const welcometext({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 490, left: 30),
        child: Text('Welcome to DCCM',
            style: GoogleFonts.poppins(
                color: spruce, fontWeight: FontWeight.bold, fontSize: 24)));
  }
}

// ignore: camel_case_types
class launchimage extends StatelessWidget {
  const launchimage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
        child: SizedBox(
            height: 400,
            width: 350,
            child: Image.asset('images/launchscreen.png')));
  }
}
