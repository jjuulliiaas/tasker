import 'package:flutter/material.dart';
import 'package:tasker/screens/history.dart';
import '../database/db_helper.dart';
import '../theme/colors.dart';
import '../theme/styled_text.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/task_container.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_sliver_app_bar.dart';
import '../screens/add_task.dart';
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
  Map<String, dynamic>? _user; // Локальна змінна для збереження користувача

  final List<Map<String, String>> tasks = [
    {
      'title': 'Create design',
      'time': '10:00-12:00',
      'description': 'Design the app UI.',
    },
    {
      'title': 'Develop UI',
      'time': '12:00-14:00',
      'description': 'Code the UI components.',
    },
    {
      'title': 'Testing',
      'time': '14:00-16:00',
      'description': 'Test the app for bugs.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _userFuture = DatabaseHelper.instance.getUserById(widget.userId);
  }

  void _deleteAccount() async {
    try {
      await DatabaseHelper.instance.deleteAccount(widget.userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }

  void _logOut() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
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
            _user = snapshot.data; // Зберігаємо користувача
            final userName = _user!['user_name'] ?? 'Unknown';
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
              child: custom.CustomSearchBar(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
              child: StyledText.accentLabel(
                text: 'Today, 1 December',
                color: Colors.black,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  child: TaskContainer(
                    title: tasks[index]['title']!,
                    time: tasks[index]['time']!,
                    description: tasks[index]['description']!,
                    onDismissed: () {
                      setState(() {
                        tasks.removeAt(index);
                      });
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
          // Already on home
        },
        onHistoryTap: () {
          if (_user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryPage(
                  user: _user!, // Передаємо користувача
                ),
              ),
            );
          }
        },
        onAddTaskTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
        isHomeSelected: true,
        isHistorySelected: false,
      ),
    );
  }
}
