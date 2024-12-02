import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasker/screens/add_task.dart';
import 'package:tasker/theme/colors.dart';
import 'package:tasker/widgets/main_buttons.dart';
import 'package:tasker/widgets/search_bar.dart' as custom;
import '../theme/styled_text.dart';
import '../widgets/custom_sliver_app_bar.dart';

class CalendarPage extends StatefulWidget {
  final int userId; // Додаємо userId

  CalendarPage({required this.userId});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsList.kAppBackground,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            expandedHeight: 150.0,
            backgroundColor: ColorsList.kLightGreen,
            title: StyledText.mainHeading(text: 'Calendar', color: Colors.white),
            flexibleChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  iconSize: 30,
                  color: Colors.black,
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
                padding: EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0, right: 30.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskPage(userId: widget.userId), // Передаємо userId
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
                    selectedTextStyle: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
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
                    leftChevronIcon: Icon(Icons.chevron_left, color: ColorsList.kDarkGreen),
                    rightChevronIcon: Icon(Icons.chevron_right, color: ColorsList.kDarkGreen),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: ColorsList.kDarkGreen, fontSize: 10, fontWeight: FontWeight.bold),
                    weekdayStyle: TextStyle(color: ColorsList.kDarkGreen, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                // TO DO replace this with my task items:
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Task title'),
                      subtitle: Text('Task details'),
                    ),
                  ),
                );
              },
              childCount: 5, // TO DO count
            ),
          ),
        ],
      ),
    );
  }
}
