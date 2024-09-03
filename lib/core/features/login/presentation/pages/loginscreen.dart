import 'package:dccm/Colors.dart';
import 'package:dccm/core/features/login/presentation/bloc/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'loginscreenwidget.dart';

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
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: AppBar(
            backgroundColor: parchment,
          )),
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
            Navigator.pushReplacementNamed(context, '/login');
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
                          onChangedEmail: (value) =>
                              setState(() => email = value),
                          onChangedPassword: (value) =>
                              setState(() => password = value),
                          onSubmit: () {
                            if (checkvalide()) {
                              context.read<LoginBloc>().add(
                                  loginbuttonclickedevent(
                                      emailvalidate: email,
                                      passwordvalidate: password));
                            }
                          })
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }

  Image _loginimage() => Image.asset('images/Login.png');
}
