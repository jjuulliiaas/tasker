import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/db_helper.dart';
import '../theme/colors.dart';
import '../theme/styled_text.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/bottom_nav_bar.dart';
import '../widgets/main_buttons.dart';
import '../widgets/custom_sliver_app_bar.dart';
import '../screens/add_task.dart';
import 'login.dart';

class HistoryPage extends StatefulWidget {
  final int userId; // Передаємо userId

  HistoryPage({required this.userId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<Map<String, dynamic>?> _userFuture;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _userFuture = DatabaseHelper.instance.getUserById(widget.userId);
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
            expandedHeight: 150.0,
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
              padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
              child: custom.CustomSearchBar(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 200.0),
              child: MainButton(
                width: 30,
                height: 10,
                child: Row(
                  children: [
                    Icon(Icons.add_rounded, color: Colors.white),
                    StyledText.accentLabel(text: 'Add Task', color: Colors.white),
                  ],
                ),
                color: ColorsList.kDarkGreen,
                padding: EdgeInsets.only(
                    left: 30.0, top: 20.0, bottom: 20.0, right: 30.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskPage(userId: widget.userId),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime(2015),
                  lastDay: DateTime(2101),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(fontSize: 10),
                    weekendTextStyle: TextStyle(fontSize: 10),
                    outsideTextStyle: TextStyle(fontSize: 10, color: Colors.grey),
                    selectedTextStyle: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    todayTextStyle: TextStyle(fontSize: 11, color: Colors.white),
                    selectedDecoration: BoxDecoration(
                      color: ColorsList.kDarkGreen,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: ColorsList.kLightGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 12,
                    ),
                    leftChevronIcon:
                    Icon(Icons.chevron_left, color: ColorsList.kDarkGreen),
                    rightChevronIcon:
                    Icon(Icons.chevron_right, color: ColorsList.kDarkGreen),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(
                        color: ColorsList.kDarkGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                    weekdayStyle: TextStyle(
                        color: ColorsList.kDarkGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Task title'),
                      subtitle: Text('Task details'),
                    ),
                  ),
                );
              },
              childCount: 5,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        onHomeTap: () {
          Navigator.pop(context); // Повернення на головну
        },
        onHistoryTap: () {
          // Already on history
        },
        onAddTaskTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage(userId: widget.userId)),
          );
        },
        isHomeSelected: false,
        isHistorySelected: true,
      ),
    );
  }
}
