import 'package:flutter/material.dart';
import 'package:tasker/screens/add_task.dart';
import 'package:tasker/screens/history.dart';
import '../database/db_helper.dart';
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
  Future<List<Map<String, dynamic>>>? _tasksFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = DatabaseHelper.instance.getUserById(widget.userId);
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _tasksFuture = DatabaseHelper.instance.getTasksByDate(
        widget.userId,
        DateTime.now().toString().split(' ')[0],
      );
    });
  }

  Future<void> _deleteTask(int taskId) async {
    try {
      await DatabaseHelper.instance.deleteTask(taskId);
      _loadTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e')),
      );
    }
  }

  Future<void> _toggleTaskCompletion(Map<String, dynamic> task) async {
    try {
      final newStatus = task['task_status_id'] == 1 ? 0 : 1;
      await DatabaseHelper.instance.updateTaskStatus(task['task_id'], newStatus);
      _loadTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task status: $e')),
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

  Future<void> _editTask(Map<String, dynamic> task) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
          userId: widget.userId,
          task: task,
        ),
      ),
    );
    if (updated == true) {
      _loadTasks();
    }
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
            flexibleChild: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(Icons.menu, color: Colors.white),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CustomSearchBar(),
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _tasksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
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
              final tasks = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final task = tasks[index];
                    return GestureDetector(
                      onTap: () => _editTask(task),
                      child: TaskContainer(
                        task: task,
                        onDelete: () => _deleteTask(task['task_id']),
                        onToggleComplete: () => _toggleTaskCompletion(task),
                      ),
                    );
                  },
                  childCount: tasks.length,
                ),
              );
            },
          ),
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
          ).then((_) => _loadTasks());
        },
        isHomeSelected: true,
        isHistorySelected: false,
      ),
    );
  }
}
