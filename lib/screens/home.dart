import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/styled_text.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/task_container.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_sliver_app_bar.dart';
import '../screens/add_task.dart';
import '../screens/account_settings.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
      backgroundColor: ColorsList.kAppBackground,

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: ColorsList.kDarkGreen,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 40,),
                    StyledText.mainHeading(text: 'Name', color: Colors.white,) ])
            ),
            // drawer elements:
            ListTile(
              leading: Icon(Icons.home, color: ColorsList.kLightGreen,),
              title: StyledText.accentLabel(text: 'Home', color: ColorsList.kDarkGreen,),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: ColorsList.kLightGreen,),
              title: StyledText.accentLabel(text: 'History', color: ColorsList.kDarkGreen,),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: ColorsList.kLightGreen,),
              title: StyledText.accentLabel(text: 'Settings', color: ColorsList.kDarkGreen,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountSettings())
                );
              },
            ),
          ],
        ),
      ),

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
                    _scaffoldKey.currentState?.openDrawer();
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
          Navigator.push(
              context,
            MaterialPageRoute(builder: (context) => AddTaskPage())
          );
        },
        isHomeSelected: true,
        isHistorySelected: false,
      ),
    );
  }
}
