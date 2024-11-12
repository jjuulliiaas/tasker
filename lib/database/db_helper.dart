import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasker.db');

    // check on existing of database
    final exists = await databaseExists(path);

    if (!exists) {
      // copying from assets if file is not here
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load('assets/db/tasker.db');
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        print("Error with copying database: $e");
      }
    }

    return await openDatabase(path);
  }

  // create task
  Future<int> createTask(Map<String, dynamic> task) async {
    final db = await instance.database;
    return await db.insert('tasks', task);
  }

  // load tasks from db
  Future<List<Map<String, dynamic>>> readAllTasks() async {
    final db = await instance.database;
    return await db.query('tasks');
  }

  // close db
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
