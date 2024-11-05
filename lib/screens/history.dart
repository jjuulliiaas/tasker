import 'package:flutter/material.dart';
import 'package:tasker/screens/home.dart';
import '../theme/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import 'add_task.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsList.kAppBackground,
      body: CustomScrollView(

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        onHomeTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage())
          );
        },
        onHistoryTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryPage())
          );
        },
        onAddTaskTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskPage())
          );
        },
        isHomeSelected: false,
        isHistorySelected: true,
      ),
    );
  }
}
