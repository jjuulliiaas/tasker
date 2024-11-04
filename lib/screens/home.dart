import 'package:flutter/material.dart';
import 'package:tasker/widgets/custom_sliver_app_bar.dart';
import 'package:tasker/theme/colors.dart';
import 'package:tasker/theme/styled_text.dart';
import 'package:tasker/widgets/search_bar.dart' as custom;
import '../widgets/task_container.dart';
import '../widgets/bottom_nav_bar.dart';

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
            expandedHeight: 180.0,
            backgroundColor: ColorsList.kDarkGreen,
            title: StyledText.mainHeading(text: 'My Tasks', color: Colors.white),
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
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: custom.CustomSearchBar(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
              child: StyledText.accentLabel(text: 'Today, 1 December', color: Colors.black,)
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        onHomeTap: () {
          // TO DO actions for home button
        },
        onHistoryTap: () {
          // TO DO actions for history button
        },
        onAddTaskTap: () {
          // TO DO actions for add task button
        },
        isHomeSelected: true,
        isHistorySelected: false,
      ),
    );
  }
}
