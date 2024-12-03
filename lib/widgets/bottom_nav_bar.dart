import 'package:flutter/material.dart';
import 'package:tasker/theme/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function() onHomeTap;
  final Function() onHistoryTap;
  final Function() onAddTaskTap;
  final bool isHomeSelected;
  final bool isHistorySelected;

  CustomBottomNavigationBar({
    required this.onHomeTap,
    required this.onHistoryTap,
    required this.onAddTaskTap,
    this.isHomeSelected = false,
    this.isHistorySelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: ColorsList.kBottomNav,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: onHomeTap,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isHomeSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.home, size: 40, color: Colors.white),
                ),
              ),
              SizedBox(width: 40),

              GestureDetector(
                onTap: onHistoryTap,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isHistorySelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.history, size: 40, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 30.0,
          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              onPressed: onAddTaskTap,
              child: Icon(Icons.add_rounded, size: 35, color: Colors.white),
              backgroundColor: ColorsList.kDarkGreen,
              elevation: 5,
              shape: CircleBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
