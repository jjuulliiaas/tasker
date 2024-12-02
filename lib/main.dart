import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/provider/task_provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(1), // Передайте userId
        ),
      ],
      child: MaterialApp(
        title: 'Tasker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorsList.kDarkGreen),  useMaterial3: true,),
        debugShowCheckedModeBanner: false,
        home: HomePage(userId: 1),
      ),
    );
  }
}

