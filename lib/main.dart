import 'package:flutter/material.dart';
import 'package:tasker/screens/home.dart';
import 'package:tasker/screens/login.dart';
import 'package:tasker/theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tasker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorsList.kDarkGreen),
          useMaterial3: true,
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.green[800],
            contentTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
            actionTextColor: Colors.yellow,
            elevation: 5,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      );
  }
}

