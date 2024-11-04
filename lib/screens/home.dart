import 'package:flutter/material.dart';
import 'package:tasker/widgets/custom_sliver_app_bar.dart';
import 'package:tasker/theme/colors.dart';
import 'package:tasker/theme/styled_text.dart';
import 'package:tasker/widgets/search_bar.dart' as custom;
import '../widgets/task_container.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> tasks = [
    {
      'title': 'Create design',
      'time': '10:00-12:00',
      'description': 'description description description description'
    },
    {
      'title': 'Develop UI',
      'time': '12:00-14:00',
      'description': 'description description description description'
    },
    {
      'title': 'Testing',
      'time': '14:00-16:00',
      'description': 'description description description description'
    },
    {
      'title': 'Testing',
      'time': '14:00-16:00',
      'description': 'description description description description'
    },
    {
      'title': 'Testing',
      'time': '14:00-16:00',
      'description': 'description description description description'
    },
    {
      'title': 'Testing',
      'time': '14:00-16:00',
      'description': 'description description description description'
    },
    {
      'title': 'Testing',
      'time': '14:00-16:00',
      'description': 'description description description description'
    },
    {
      'title': 'Go shopping with friend',
      'time': '14:00-16:00',
      'description': 'description description description description'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsList.kAppBackground,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            expandedHeight: 200.0,
            backgroundColor: ColorsList.kDarkGreen,
            title: Text('My Tasks', style: TextStyle(color: Colors.white)),
            flexibleChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    // TO DO actions
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.view_headline_rounded),
                  iconSize: 50,
                  color: ColorsList.kAuthBackground,
                ),
                SizedBox(height: 20),
                StyledText.defaultLabel(
                  text: 'Date',
                  color: ColorsList.kAppBackground,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: custom.CustomSearchBar(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: TaskContainer(
                    title: tasks[index]['title']!,
                    time: tasks[index]['time']!,
                    description: tasks[index]['description']!,
                    onDismissed: () {
                      tasks.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task removed')),
                      );
                    },
                  ),
                );
              },
              childCount: tasks.length,
            ),
          ),
        ],
      ),
    );
  }
}
