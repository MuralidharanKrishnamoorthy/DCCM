import 'package:dccm/core/binding/binding.dart';
import 'package:dccm/core/features/launch/presentation/pages/launchscreen.dart';
import 'package:dccm/core/features/login/presentation/pages/loginscreen.dart';
import 'package:dccm/core/features/register/presentation/bloc/bloc/register_bloc.dart';

import 'package:dccm/core/features/register/presentation/pages/registerscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    String? deviceid = await getdeviceinfo();
    print("device id , $deviceid");
  } catch (e) {
    print("$e");
  }

  runApp(MultiBlocProvider(providers: [
    BlocProvider<RegisterBloc>(create: (context) => RegisterBloc())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LaunchScreen(),
        '/Registerscreen': (context) => const Registerscreen(),
        '/Login': (context) => const Loginscreen()
      },
    );
  }
}
