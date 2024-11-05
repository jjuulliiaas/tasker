import 'package:flutter/material.dart';
import 'package:tasker/screens/home.dart';
import 'package:tasker/widgets/main_buttons.dart';
import '../theme/colors.dart';
import '../theme/styled_text.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_sliver_app_bar.dart';
import '../widgets/search_bar.dart' as custom;
import 'account_settings.dart';
import 'add_task.dart';

class HistoryPage extends StatefulWidget {

  @override
  State<HistoryPage> createState() => _HistoryPageState();

}

class _HistoryPageState extends State<HistoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

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
            backgroundColor: ColorsList.kLightGreen,
            title: StyledText.mainHeading(text: 'History', color: Colors.white),
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
                )),
          ),

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        onHomeTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage())
          );
        },
        onHistoryTap: () {
          //
        },
        onAddTaskTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskPage())
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
