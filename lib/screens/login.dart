import 'package:flutter/material.dart';
import 'package:tasker/screens/signup.dart';
import 'package:tasker/theme/colors.dart';
import 'package:tasker/theme/styled_text.dart';
import 'package:tasker/widgets/main_buttons.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid e-mail';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Must be at least 6 characters';
    }
    return null;
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsList.kAuthBackground,
      body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 100.0, bottom: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
              children: [Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 120,
                ),
              ),
              SizedBox(height: 30,),
              StyledText.mainHeading(text: 'Welcome back!', color: ColorsList.kDarkGreen),
              ]),
              SizedBox(height: 50,),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          helperText: 'E-mail',
                          helperStyle: TextStyle(
                            fontSize: 10,
                              fontFamily: 'Comfortaa',
                              color: ColorsList.kDarkGreen
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          helperText: 'Password',
                          helperStyle: TextStyle(
                              fontSize: 10,
                            fontFamily: 'Comfortaa',
                            color: ColorsList.kDarkGreen
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: _validatePassword,
                        obscureText: true,
                      ),
                      SizedBox(height: 40,),
                      MainButton(
                          width: 30,
                          height: 10,
                          child: StyledText.accentLabel(text: 'Log In', color: Colors.white),
                          color: ColorsList.kDarkGreen,
                          padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            }
                          }, )
                    ],
                  )),
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledText.defaultLabel(
                      text: 'Don`t have an account yet?',
                      color: Colors.black),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignupPage()));
                      },
                      child: StyledText.defaultLabel(text: 'Sign Up', color: Colors.blue)),
                ],
              )
        ],
      ),
      )
    );
  }
}
