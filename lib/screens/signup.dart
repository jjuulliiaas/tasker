import 'package:flutter/material.dart';
import 'package:tasker/screens/login.dart';
import 'package:tasker/theme/colors.dart';
import 'package:tasker/theme/styled_text.dart';
import 'package:tasker/widgets/main_buttons.dart';

class SignupPage extends StatefulWidget {

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

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
    _nameController.dispose();
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
                    StyledText.mainHeading(text: 'Let`s get started!', color: ColorsList.kDarkGreen),
                  ]),
              SizedBox(height: 50,),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          helperText: 'Name',
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
                        validator: _validateName,
                      ),
                      SizedBox(height: 20),
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
                        child: StyledText.accentLabel(text: 'Sign Up', color: Colors.white),
                        color: ColorsList.kDarkGreen,
                        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                          }
                        }, )
                    ],
                  )),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledText.defaultLabel(
                      text: 'Already have an account?',
                      color: Colors.black),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      child: StyledText.defaultLabel(text: 'Log In', color: Colors.blue)),
                ],
              )
            ],
          ),
        )
    );
  }
}
