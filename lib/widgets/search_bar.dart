import 'package:flutter/material.dart';
import 'package:tasker/theme/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                cursorColor: ColorsList.kDarkGreen,
                style: TextStyle(fontSize: 11),
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 13.0, horizontal: 15.0),
                  suffixIcon: Icon(Icons.search, color: ColorsList.kDarkGreen),
                  labelText: 'Search tasks...',
                  labelStyle: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                onChanged: (value) {
                  // if (onSearchChanged != null) {
                  //   onSearchChanged!(value); // Викликаємо зовнішню логіку пошуку
                  // }
                },
              ),
            ),
          // ),
          // SizedBox(width: 20),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => CalendarPage(user: user), // Передаємо користувача
          //       ),
          //     );
          //   },
          //   child: Container(
          //     height: 40.0,
          //     width: 40.0,
          //     decoration: BoxDecoration(
          //       color: ColorsList.kLightGreen,
          //       shape: BoxShape.circle,
          //     ),
          //     child: Icon(Icons.calendar_month_rounded, color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}
