import 'package:flutter/material.dart';
import 'package:tasker/theme/colors.dart';
import 'package:tasker/theme/styled_text.dart';
import 'package:tasker/widgets/top_container.dart';
import 'package:tasker/widgets/main_buttons.dart';
import '../database/db_helper.dart';

class AddTaskPage extends StatefulWidget {
  final int userId;
  final Map<String, dynamic>? task;

  AddTaskPage({required this.userId, this.task});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late bool isHighPriority;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Initialize fields for editing
      titleController = TextEditingController(text: widget.task!['task_title']);
      descriptionController =
          TextEditingController(text: widget.task!['task_description']);
      selectedDate = DateTime.parse(widget.task!['task_due_date']);
      startTime = _parseTime(widget.task!['task_start_time']);
      endTime = _parseTime(widget.task!['task_end_time']);
      isHighPriority = widget.task!['task_priority'] == 1;
    } else {
      // Initialize fields for creating
      titleController = TextEditingController();
      descriptionController = TextEditingController();
      selectedDate = DateTime.now();
      startTime = TimeOfDay(hour: 10, minute: 0);
      endTime = TimeOfDay(hour: 12, minute: 0);
      isHighPriority = false;
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  Future<void> _saveTask() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    final task = {
      'user_id': widget.userId,
      'task_title': titleController.text,
      'task_description': descriptionController.text,
      'task_due_date': formattedDate,
      'task_start_time': startTime.format(context),
      'task_end_time': endTime.format(context),
      'task_priority': isHighPriority ? 1 : 0,
      'task_status_id': widget.task?['task_status_id'] ?? 0,
    };

    try {
      if (widget.task != null) {
        await DatabaseHelper.instance.updateTask(widget.task!['task_id'], task);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task updated successfully!')),
        );
      } else {
        await DatabaseHelper.instance.insertTask(task);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task created successfully!')),
        );
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save task: $e')),
      );
    }
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
              padding: EdgeInsets.all(30.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
                size: 25,
                ),
              ),
              SizedBox(height: 20),
              if (widget.task == null)
                StyledText.mainHeading(
                  text: 'Create new task',
                  color: Colors.black,
                ),
              SizedBox(height: 15),
    TextField(
    controller: titleController,
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
    style: TextStyle(fontSize: 12),
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
    child: Icon(Icons.calendar_month_rounded,
    color: Colors.white),
    ),
    ),
    enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    ),
    focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    ),
    ),
    controller: TextEditingController(
    text:
    "${selectedDate.toLocal()}".split(' ')[0]),
    ),
    ),
    ],
    ),
    SizedBox(height: 20),
    ],
    ),
    ),
    SizedBox(height: 20),
    Padding(
    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    StyledText.defaultLabel(
    text: 'Start Time',
    color: ColorsList.kDarkGreen,
    ),
    SizedBox(height: 8),
    GestureDetector(
    onTap: () => _selectTime(context, true),
    child: StyledText.accentLabel(
    text: startTime.format(context),
    color: ColorsList.kDarkGreen,
    ),
    ),
    ],
    ),
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    StyledText.defaultLabel(
    text: 'End Time',
    color: ColorsList.kDarkGreen,
    ),
    SizedBox(height: 8),
    GestureDetector(
    onTap: () => _selectTime(context, false),
    child: StyledText.accentLabel(
    text: endTime.format(context),
    color: ColorsList.kDarkGreen,
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    Padding(
    padding:
    EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
    child: TextField(
    controller: descriptionController,
    maxLines: 3,
    maxLength: 300,
    decoration: InputDecoration(
    labelText: 'Description',
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
    ),
    Padding(
    padding:
    EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
    child: MainButton(
    onPressed: () {
    setState(() {
    isHighPriority = !isHighPriority;
    });
    },
      width: 34,
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.star,
            color: isHighPriority ? Colors.yellow : Colors.grey,
          ),
          SizedBox(width: 8),
          StyledText.defaultLabel(
            text: 'High Importance',
            color: ColorsList.kDarkGreen,
          ),
        ],
      ),
      color: Colors.white,
      padding:
      EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    ),
    ),
      Spacer(),
      Center(
        child: MainButton(
          onPressed: _saveTask,
          width: 40,
          height: 10,
          child: StyledText.accentLabel(
            text: widget.task != null ? 'Update Task' : 'Create Task',
            color: Colors.white,
          ),
          color: ColorsList.kLightGreen,
          padding: EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 20.0),
        ),
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

