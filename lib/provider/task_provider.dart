import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class TaskProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];
  Map<String, dynamic>? _user;

  List<Map<String, dynamic>> get tasks => _tasks;
  Map<String, dynamic>? get user => _user;

  Future<void> loadTasksForToday(int userId) async {
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    try {
      _tasks = await DatabaseHelper.instance.getTasksByDate(userId, formattedDate);
      notifyListeners();
    } catch (e) {
      print("Failed to load tasks: $e");
    }
  }

  void toggleTaskCompletion(int taskId) async {
    try {
      // Знайдіть завдання у списку
      final taskIndex = tasks.indexWhere((task) => task['task_id'] == taskId);
      if (taskIndex == -1) return;

      // Отримайте поточний статус
      final currentStatus = tasks[taskIndex]['task_status_id'];

      // Змінити статус у базі даних
      final newStatus = currentStatus == 1 ? 0 : 1;
      await DatabaseHelper.instance.updateTaskStatus(taskId, newStatus);

      // Оновіть статус у локальному списку
      tasks[taskIndex]['task_status_id'] = newStatus;

      // Оновіть UI
      notifyListeners();
    } catch (e) {
      print("Failed to update task status: $e");
    }
  }




  void deleteTask(int taskId) {
    tasks.removeWhere((task) => task['task_id'] == taskId);
    notifyListeners();
  }


  Future<void> loadUserData(int userId) async {
    try {
      _user = await DatabaseHelper.instance.getUserById(userId);
      notifyListeners();
    } catch (e) {
      print("Failed to load user data: $e");
    }
  }

  Future<void> deleteAccount(int userId) async {
    try {
      await DatabaseHelper.instance.deleteAccount(userId);
      _user = null;
      _tasks = [];
      notifyListeners();
    } catch (e) {
      print("Failed to delete account: $e");
    }
  }
}
