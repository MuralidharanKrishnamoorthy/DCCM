// ignore_for_file: prefer_const_constructors
import 'package:dccm/core/binding/bloc/devicebinding_bloc.dart';
import 'package:dccm/core/features/login/presentation/bloc/bloc/login_bloc.dart';
import 'package:dccm/core/features/register/data/datasource.dart'
    as registerdatasource;
import 'package:dccm/core/features/register/presentation/bloc/bloc/register_bloc.dart';
import 'package:dccm/core/utils/Company/CompanyNavigation.dart';
import 'package:dccm/core/utils/ProjectDeveloper/ProjectDeveloperNavigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dccm/core/features/launch/presentation/pages/launchscreen.dart';
import 'package:dccm/core/features/login/presentation/pages/loginscreen.dart';
import 'package:dccm/core/features/register/presentation/pages/registerscreen.dart';
import 'package:dccm/core/features/login/data/datasource.dart'
    as logindatasource;

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(
            create: (context) =>
                RegisterBloc(registerdatasource.AuthRepository())),
        BlocProvider<DevicebindingBloc>(
            create: (context) => DevicebindingBloc()),
        BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(logindatasource.AuthRepository(
                baseUrl: 'http://192.168.1.6:8080/api/dccm')))
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<DevicebindingBloc, DevicebindingState>(
        builder: (context, state) {
          if (state is DeviceBindingInitial) {
            context.read<DevicebindingBloc>().add(Devicebindingcheckevent());
            return LaunchScreen();
          } else if (state is DeviceBindingLoading) {
            return LaunchScreen();
          } else if (state is DeviceBindingComplete) {
            return state.isBound ? Loginscreen() : Registerscreen();
          } else if (state is DeviceBindingError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${(state as DeviceBindingError).error}'),
              ),
            );
          }
          return LaunchScreen();
        },
      ),
      routes: {
        //'/': (context) => LaunchScreen(),
        '/Registerscreen': (context) => Registerscreen(),
        '/Login': (context) => Loginscreen(),
        '/Company': (context) => CompanyNavigation(),
        '/Projectdeveloper': (context) => Projectdevnavigation(
              projectCounts: {},
            )
      },
    );
  }
}
