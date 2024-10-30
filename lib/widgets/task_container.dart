import 'package:flutter/material.dart';
import 'package:tasker/theme/colors.dart';
import 'package:tasker/theme/styled_text.dart';

class TaskContainer extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final VoidCallback onDismissed;

  TaskContainer({
    required this.title,
    required this.time,
    required this.description,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(title),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        onDismissed();
      },
      background: Container(
        color: ColorsList.kRed,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(Icons.delete_forever, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: ColorsList.kRed,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete_forever, color: Colors.white),
      ),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: ColorsList.kGrey,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: ColorsList.kAuthBackground),
                    ),
                    child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: ColorsList.kDarkGreen,
                        ),),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Comfortaa',
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
