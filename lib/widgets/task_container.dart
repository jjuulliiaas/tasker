import 'package:flutter/material.dart';
import 'package:tasker/theme/colors.dart';

class TaskContainer extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final bool isHighPriority;
  final bool isCompleted; // Додано поле для перевірки виконаності
  final VoidCallback onDismissed;
  final VoidCallback onToggleComplete; // Колбек для зміни статусу виконання

  TaskContainer({
    required this.title,
    required this.time,
    required this.description,
    this.isHighPriority = false,
    this.isCompleted = false,
    required this.onDismissed,
    required this.onToggleComplete,
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
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onToggleComplete, // Викликаємо функцію при натисканні
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: isCompleted ? Colors.green : ColorsList.kGrey,
                      child: isCompleted
                          ? Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.grey : Colors.black,
                        decoration:
                        isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  if (isHighPriority)
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 13.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: ColorsList.kAuthBackground),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: ColorsList.kDarkGreen,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 9,
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
