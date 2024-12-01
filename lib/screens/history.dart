import 'package:flutter/material.dart';
import 'package:tasker/screens/home.dart';
import '../database/db_helper.dart';
import '../theme/colors.dart';
import '../theme/styled_text.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/bottom_nav_bar.dart';
import '../widgets/main_buttons.dart';
import '../widgets/custom_sliver_app_bar.dart';
import '../screens/add_task.dart';

class HistoryPage extends StatefulWidget {
  final Map<String, dynamic> user; // Передаємо інформацію про користувача

  HistoryPage({required this.user});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _logOut() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage(userId: widget.user['user_id'])),
          (route) => false,
    );
  }

  void _deleteAccount() async {
    try {
      await DatabaseHelper.instance.deleteAccount(widget.user['user_id']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: widget.user['user_id'])),
            (route) => false,
      );
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

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorsList.kAppBackground,
      drawer: Drawer(
        child: ListView(
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
                    text: widget.user['user_name'] ?? 'Unknown',
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
        ),
      ),
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            expandedHeight: 180.0,
            backgroundColor: ColorsList.kLightGreen,
            title: StyledText.mainHeading(
              text: 'History',
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterButton(0, 'All', ColorsList.kDarkGreen),
                  _buildFilterButton(1, 'Done', Colors.green, Icons.circle),
                  _buildFilterButton(2, 'Miss', Colors.red, Icons.circle),
                  _buildFilterButton(3, 'Important', Colors.yellow, Icons.star),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        onHomeTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(userId: widget.user['user_id']),
            ),
          );
        },
        onHistoryTap: () {
          // Already on history page
        },
        onAddTaskTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
        isHomeSelected: false,
        isHistorySelected: true,
      ),
    );
  }

  Widget _buildFilterButton(int index, String label, Color iconColor, [IconData? icon]) {
    bool isActive = selectedIndex == index;
    return MainButton(
      width: 10,
      height: 5,
      color: isActive ? ColorsList.kAuthBackground : Colors.white,
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, size: 15, color: iconColor),
          if (icon != null) SizedBox(width: 5),
          StyledText.defaultLabel(
            text: label,
            color: isActive ? ColorsList.kDarkGreen : ColorsList.kDarkGreen,
          ),
        ],
      ),
    );
  }
}
