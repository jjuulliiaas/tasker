import 'package:flutter/material.dart';
import 'package:tasker/theme/colors.dart';
import 'package:tasker/theme/styled_text.dart';
import 'package:tasker/widgets/top_container.dart';
import 'package:tasker/widgets/main_buttons.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  String title = "";
  String description = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 10, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 12, minute: 0);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null)
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsList.kAppBackground,
      body: SingleChildScrollView(
          child: ConstrainedBox(
          constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
      ),
      child: IntrinsicHeight(
        child: Column(
          children: [
          TopContainer(
            width: MediaQuery.of(context).size.width,
              height: 350,
              color: ColorsList.kAuthBackground,
              padding: EdgeInsets.only(left: 30.0, top: 40.0, bottom: 20.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, 
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                        size: 25,)),
                  SizedBox(height: 20),
                  StyledText.mainHeading(
                  text: 'Create new task',
                  color: Colors.black,
                  ),
                  SizedBox(height: 15),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                          color: ColorsList.kDarkGreen,
                          fontSize: 12,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 12
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(
                              color: ColorsList.kDarkGreen,
                              fontSize: 12,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                               _selectDate(context);
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
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          controller: TextEditingController(text: "${selectedDate.toLocal()}".split(' ')[0]),
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledText.defaultLabel(
                        text: 'Start',
                        color: ColorsList.kDarkGreen,
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectTime(context, true),
                        child: StyledText.accentLabel(
                          text: startTime.format(context),
                          color: ColorsList.kDarkGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledText.defaultLabel(
                        text: 'End',
                        color: ColorsList.kDarkGreen,
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectTime(context, false),
                        child: StyledText.accentLabel(
                          text: endTime.format(context),
                          color: ColorsList.kDarkGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      maxLines: 3,
                      maxLength: 300,
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Decription',
                        labelStyle: TextStyle(
                          color: ColorsList.kDarkGreen,
                          fontSize: 12,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    MainButton(
                        onPressed: () {
                          // TO DO actions for marking task as VERY important
                        },
                        width: 34,
                        height: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star, color: Colors.yellow,),
                            StyledText.defaultLabel(text: 'High Importance', color: ColorsList.kDarkGreen)
                          ],
                        ),
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8))
                  ],
                )),
            Spacer(),
            Center(
              child: MainButton
                (onPressed: () {
                  // TO DO actions for creating task
              },
                  width: 40,
                  height: 10,
                  child: StyledText.accentLabel(text: 'Create Task', color: Colors.white),
                  color: ColorsList.kLightGreen,
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0))
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      ),
      ),
    );
  }
}
