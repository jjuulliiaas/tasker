import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/screens/add_task.dart';
import 'package:tasker/screens/history.dart';
import '../database/db_helper.dart';
import '../provider/task_provider.dart';
import '../theme/colors.dart';
import '../theme/styled_text.dart';
import '../widgets/task_container.dart';
import '../widgets/custom_sliver_app_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  final int userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<Map<String, dynamic>?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = DatabaseHelper.instance.getUserById(widget.userId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasksForToday(widget.userId);
    });
  }

  void _logOut() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }

  void _deleteAccount() async {
    try {
      await DatabaseHelper.instance.deleteAccount(widget.userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully!')),
      );
      _logOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorsList.kAppBackground,
      drawer: Drawer(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: StyledText.mainHeading(
                  text: 'Error loading user',
                  color: Colors.red,
                ),
              );
            }
            final userName = snapshot.data!['user_name'] ?? 'Unknown';
            return ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: ColorsList.kDarkGreen),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 40,
                      ),
                      SizedBox(height: 10),
                      StyledText.mainHeading(
                        text: userName,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: ColorsList.kDarkGreen),
                  title: StyledText.accentLabel(
                    text: 'Log Out',
                    color: ColorsList.kDarkGreen,
                  ),
                  onTap: _logOut,
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: StyledText.accentLabel(
                    text: 'Delete Account',
                    color: Colors.red,
                  ),
                  onTap: _showDeleteAccountDialog,
                ),
              ],
            );
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            expandedHeight: 180.0,
            backgroundColor: ColorsList.kDarkGreen,
            title: StyledText.mainHeading(
              text: 'My Tasks',
              color: Colors.white,
            ),
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
              child: CustomSearchBar(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
              child: StyledText.accentLabel(
                text: 'Today\'s Tasks',
                color: Colors.black,
              ),
            ),
          ),
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              if (taskProvider.tasks.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: StyledText.accentLabel(
                        text: 'No tasks for today',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final task = taskProvider.tasks[index];
                    return Dismissible(
                      key: Key(task['task_id'].toString()),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        taskProvider.deleteTask(task['task_id']);
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
                      child: TaskContainer(task: task),
                    );
                  },
                  childCount: taskProvider.tasks.length,
                ),
              );

            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        onHomeTap: () {},
        onHistoryTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryPage(userId: widget.userId),
            ),
          );
        },
        onAddTaskTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskPage(userId: widget.userId),
            ),
          ).then((_) {
            Provider.of<TaskProvider>(context, listen: false).loadTasksForToday(widget.userId);
          });
        },
        isHomeSelected: true,
        isHistorySelected: false,
      ),
    );
  }
}
