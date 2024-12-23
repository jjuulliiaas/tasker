import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'tasker.db');
    print("Database path: $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    print("Creating database...");

    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_name TEXT NOT NULL,
        user_email TEXT NOT NULL UNIQUE,
        user_password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        task_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        task_title TEXT NOT NULL,
        task_description TEXT,
        task_due_date TEXT,
        task_start_time TEXT,
        task_end_time TEXT,
        task_status_id INTEGER,
        task_priority INTEGER,
        FOREIGN KEY (user_id) REFERENCES users(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS task_status (
        status_id INTEGER PRIMARY KEY AUTOINCREMENT,
        status_name TEXT NOT NULL
      )
    ''');

    print("Database created successfully.");
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  Future<int> userSignUp(String name, String email, String password) async {
    final db = await instance.database;

    final existingUser = await db.query(
      'users',
      where: 'user_email = ?',
      whereArgs: [email],
    );
    if (existingUser.isNotEmpty) {
      throw Exception("This e-mail is already registered.");
    }

    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    final user = {
      'user_name': name,
      'user_email': email,
      'user_password': hashedPassword,
    };

    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await instance.database;

    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    final result = await db.query(
      'users',
      where: 'user_email = ? AND user_password = ?',
      whereArgs: [email, hashedPassword],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
  final db = await database;
  return await db.insert('tasks', task);
  }


  // Отримання всіх завдань для користувача
  Future<List<Map<String, dynamic>>> readAllTasks(int userId) async {
    final db = await instance.database;
    return await db.query(
      'tasks',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateTask(int taskId, Map<String, dynamic> updatedFields) async {
    final db = await database;
    try {
      return await db.update(
        'tasks',
        updatedFields,
        where: 'task_id = ?',
        whereArgs: [taskId],
      );
    } catch (e) {
      print("Error updating task $taskId: $e");
      throw Exception("Failed to update task");
    }
  }

  Future<void> updateTaskStatus(int taskId, int status) async {
    final db = await instance.database;
    await db.update(
      'tasks',
      {'task_status_id': status},
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> deleteTask(int taskId) async {
    final db = await instance.database;
    await db.delete('tasks', where: 'task_id = ?', whereArgs: [taskId]);
  }

  Future<List<Map<String, dynamic>>> getTasksByDate(int userId, String date) async {
    final db = await database;
    try {
      final tasks = await db.query(
        'tasks',
        where: 'user_id = ? AND task_due_date = ?',
        whereArgs: [userId, date],
        orderBy: 'task_id DESC',
      );
      return tasks;
    } catch (e) {
      print("Error fetching tasks for date $date: $e");
      return [];
    }
  }


  Future<void> checkUsersTable() async {
    final db = await instance.database;
    final users = await db.rawQuery('SELECT * FROM users');
    print("Users in database: $users");
  }

  Future<void> checkTasksTable() async {
    final db = await instance.database;
    final tasks = await db.rawQuery('SELECT * FROM tasks');
    print("Tasks in database: $tasks");
  }

  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'user_id = ?',
      whereArgs: [userId],
    );


    return result.isNotEmpty ? result.first : null;
  }

  Future<void> deleteAccount(int userId) async {
    final db = await instance.database;

    await db.delete(
      'users',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    print("User with ID $userId deleted from database.");
  }

}
