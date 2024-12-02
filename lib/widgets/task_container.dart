import 'package:flutter/material.dart';
import 'package:tasker/theme/colors.dart';

class TaskContainer extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  TaskContainer({
    required this.task,
    required this.onDelete,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task['task_status_id'] == 1;
    final isHighPriority = task['task_priority'] == 1;

    return Card(
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
                  onTap: onToggleComplete,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: isCompleted ? Colors.green[800] : ColorsList.kGrey,
                    child: isCompleted
                        ? Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task['task_title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.grey : Colors.black,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                if (isHighPriority)
                  Icon(Icons.star, color: Colors.yellow, size: 25),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 13.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(color: ColorsList.kAuthBackground),
                  ),
                  child: Text(
                    "${task['task_start_time']} - ${task['task_end_time']}",
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
              task['task_description'] ?? '',
              style: TextStyle(
                fontSize: 9,
                fontFamily: 'Comfortaa',
                color: Colors.black,
                height: 1.5,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 25,),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
