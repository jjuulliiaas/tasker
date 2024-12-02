import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class TaskProvider with ChangeNotifier {
  final int userId;
  List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  TaskProvider(this.userId) {
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    try {
      _tasks = await DatabaseHelper.instance.getTasksByDate(userId, formattedDate);
      notifyListeners();
    } catch (e) {
      print("Failed to fetch tasks: $e");
    }
  }

  Future<void> toggleTaskCompletion(int taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task['task_id'] == taskId);
    if (taskIndex != -1) {
      final currentStatus = _tasks[taskIndex]['task_status_id'];
      final newStatus = currentStatus == 1 ? 0 : 1;

      try {
        await DatabaseHelper.instance.updateTaskStatus(taskId, newStatus);
        _tasks[taskIndex]['task_status_id'] = newStatus; // Оновлення статусу у локальному списку
        notifyListeners();
      } catch (e) {
        print("Failed to update task status: $e");
        throw Exception("Failed to update task status");
      }
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await DatabaseHelper.instance.deleteTask(taskId);
      _tasks.removeWhere((task) => task['task_id'] == taskId);
      notifyListeners();
    } catch (e) {
      print("Failed to delete task: $e");
      throw Exception("Failed to delete task");
    }
  }

  Future<void> addTask(Map<String, dynamic> task) async {
    try {
      await DatabaseHelper.instance.insertTask(task);
      await _fetchTasks(); // Оновлення списку завдань після додавання
    } catch (e) {
      print("Failed to add task: $e");
      throw Exception("Failed to add task");
    }
  }

  Future<void> refreshTasks() async {
    await _fetchTasks();
  }
}
