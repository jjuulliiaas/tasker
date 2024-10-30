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
            child: Container(
              height: 35.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0), // Вирівнює текст
                  suffixIcon: Icon(Icons.search, color: ColorsList.kDarkGreen),
                ),
                onChanged: (value) {
                  // TO DO:
                  //    - search logic
                },
              ),
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              // TO DO:
              //    - actions after clicking on calendar button
            },
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: ColorsList.kLightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calendar_month_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
