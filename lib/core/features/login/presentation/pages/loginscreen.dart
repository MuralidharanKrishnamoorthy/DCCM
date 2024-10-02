import 'package:dccm/Colors.dart';
import 'package:dccm/core/features/login/presentation/bloc/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'loginscreenwidget.dart';
import 'package:dccm/core/binding/binding.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  var email = '';
  var password = '';
  var deviceId = '';
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  Future<void> _loadDeviceId() async {
    final storedDeviceId = await DeviceBinding.getStoredDeviceId();
    setState(() {
      deviceId = storedDeviceId ?? '';
    });
  }

  bool checkvalide() {
    return _formkey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: spruce,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: AppBar(
          backgroundColor: parchment,
        ),
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is loginfailedstate) {
            final emailvalidate = state.emailvalidate;
            final passwordvalidate = state.passwordvalidate;
            if (emailvalidate != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(emailvalidate)));
            }
            if (passwordvalidate != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(passwordvalidate)));
            }
          }
          if (state is loginsuccessstate) {
            if (state.role == 'Company') {
              Navigator.pushReplacementNamed(context, '/Company');
            } else if (state.role == "Project Developer") {
              Navigator.pushReplacementNamed(context, '/Projectdeveloper');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid role: ${state.role}')),
              );
            }
          }
        },
        builder: (context, state) {
          return Column(
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
                    loginform(
                      formKey: _formkey,
                      email: email,
                      password: password,
                      onChangedEmail: (value) => setState(() => email = value),
                      onChangedPassword: (value) =>
                          setState(() => password = value),
                      onSubmit: () {
                        if (checkvalide()) {
                          context.read<LoginBloc>().add(
                                loginbuttonclickedevent(
                                  emailvalidate: email,
                                  passwordvalidate: password,
                                  deviceId: deviceId,
                                ),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Image _loginimage() => Image.asset('images/Login.png');
}
