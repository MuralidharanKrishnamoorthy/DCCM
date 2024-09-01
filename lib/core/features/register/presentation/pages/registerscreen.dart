import 'package:dccm/core/features/register/presentation/bloc/bloc/register_bloc.dart';
import 'package:dccm/core/features/register/presentation/pages/registerscreenwidget.dart';
import 'package:flutter/material.dart';

import 'package:dccm/Colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  var email = '';
  var password = '';
  String? selectedRole;
  final formKey = GlobalKey<FormState>();

  checkvalide() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbar(),
      body: Stack(
        children: [
          Container(
            color: spruce,
          ),
          Container(
            width: double.infinity,
            height: 570,
            decoration: BoxDecoration(
              color: parchment,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SizedBox(
                    width: constraints.maxWidth * 0.8,
                    child: BlocConsumer<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is Regfailedstate) {
                          final emailerror = state.emailcheck;
                          final passworderror = state.passwordcheck;
                          final selectedroleerror = state.selectedrolecheck;
                          if (emailerror != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(emailerror)));
                          }
                          if (passworderror != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(passworderror)));
                          }
                          if (selectedroleerror != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(selectedroleerror)));
                          }
                        }
                        if (state is Regsuccessstate) {
                          print("move to login");
                          Navigator.pushReplacementNamed(context, '/Login');
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: _registerimage(),
                            ),
                            registerform(
                              formKey: formKey,
                              onChangedEmail: (value) {
                                setState(() {
                                  email = value;
                                });
                                // context.read<RegisterBloc>().add(
                                //     Regbuttonclickedevent(
                                //         email, password, selectedRole));
                              },
                              onChangedPassword: (value) {
                                setState(() {
                                  password = value;
                                });
                                // context.read<RegisterBloc>().add(
                                //     Regbuttonclickedevent(
                                //         email, password, selectedRole));
                              },
                            ),
                            roleselection(
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value;
                                });
                                // context.read<RegisterBloc>().add(
                                //     Regbuttonclickedevent(
                                //         email, password, selectedRole));
                              },
                            ),
                            registerbutton(onSubmit: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                context.read<RegisterBloc>().add(
                                    Regbuttonclickedevent(
                                        email, password, selectedRole));
                              }
                            }),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          terms_and_conditions()
        ],
      ),
    );
  }

  Image _registerimage() {
    return Image.asset(
      'images/Registerscreen.png',
      width: 250,
    );
  }

  PreferredSize _appbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: AppBar(
        backgroundColor: parchment,
      ),
    );
  }
}
