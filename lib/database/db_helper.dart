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

    // Таблиця користувачів
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_name TEXT NOT NULL,
        user_email TEXT NOT NULL UNIQUE,
        user_password TEXT NOT NULL
      )
    ''');

    // Таблиця завдань
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

    // Таблиця статусів завдань
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

  // Реєстрація нового користувача
  Future<int> userSignUp(String name, String email, String password) async {
    final db = await instance.database;

    // Перевірка наявності користувача
    final existingUser = await db.query(
      'users',
      where: 'user_email = ?',
      whereArgs: [email],
    );
    if (existingUser.isNotEmpty) {
      throw Exception("This e-mail is already registered.");
    }

    // Хешуємо пароль
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    final user = {
      'user_name': name,
      'user_email': email,
      'user_password': hashedPassword,
    };

    return await db.insert('users', user);
  }

  // Авторизація користувача
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await instance.database;

    // Хешуємо пароль для порівняння
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    final result = await db.query(
      'users',
      where: 'user_email = ? AND user_password = ?',
      whereArgs: [email, hashedPassword],
    );

    return result.isNotEmpty ? result.first : null;
  }

  // Додавання нового завдання
  Future<int> createTask(Map<String, dynamic> task) async {
    final db = await instance.database;
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

  // Діагностичні методи
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
