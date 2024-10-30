import 'package:flutter/material.dart';
import 'package:tasker/screens/home.dart';
import 'package:tasker/theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorsList.kDarkGreen),
        useMaterial3: true,
        // textTheme: TextTheme(
        //   // bodyLarge: TextStyle(fontFamily: 'Comfortaa'),
        //   // bodyMedium: TextStyle(fontFamily: 'Comfortaa'),
        //   // displayLarge: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        //   // displayMedium: TextStyle(fontFamily: 'Montserrat'),
        // ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

