import 'package:flutter/material.dart';
import 'package:tasker/theme/colors.dart';
import 'task_container.dart';

class TaskList extends StatefulWidget {

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Map<String, String>> tasks = [
    {
      'title': 'Create design',
      'time': '10:00-12:00',
      'description': 'description description description description'
    },
    {
      'title': 'Create design',
      'time': '10:00-16:00',
      'description': 'description description description description'
    },
    {
      'title': 'Create design',
      'time': '10:00-19:00',
      'description': 'description description description description'
    },
  ];

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsList.kAppBackground,
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskContainer(
            title: tasks[index]['title']!,
            time: tasks[index]['time']!,
            description: tasks[index]['description']!,
            onDismissed: () {
              removeTask(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Task removed')),
              );
            },
          );
        },
      ),

    );
  }
}
