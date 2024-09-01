// ignore_for_file: prefer_const_constructors

import 'package:dccm/Colors.dart';
import 'package:dccm/core/features/launch/presentation/bloc/bloc/launch_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'launchwidgets.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LaunchBloc(),
        child: BlocConsumer<LaunchBloc, LaunchState>(
          listener: (context, state) {
            if (state is Getstartedloadedstate) {
              Navigator.pushReplacementNamed(context, '/Registerscreen');
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  gradientcolor(),
                  launchimage(),
                  welcometext(),
                  themetext(),
                  if (state is Getstartedloadingstate)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: SpinKitChasingDots(
                          color: spruce,
                          size: 60,
                        ),
                      ),
                    ),
                  if (state is! Getstartedloadingstate)
                    const Padding(
                      padding: EdgeInsets.only(top: 650, left: 30),
                      child: SizedBox(
                        height: 50,
                        width: 300,
                        child: Registerbutton(),
                      ),
                    ),
                ],
              ),
            );
          },
        ));
  }
}
