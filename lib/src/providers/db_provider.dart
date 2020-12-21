import 'dart:io';
import 'package:api_flutter/src/models/tasks_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  //This function returns an existing database if it exists
  //or a new one if it doesn't
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  // Create the database and the task table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'task_manager.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
      onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Task('
        'id INTEGER PRIMARY KEY,'
        'title TEXT,'
        'description TEXT'
        ')');
    });
  }

  //Insert task on database
  createTask(Task newTask) async {
    await deleteAllTasks();
    final db = await database;
    final res = await db.insert('Task', newTask.toJson());
    return res;
  }

  //Delete all tasks
  Future<int> deleteAllTasks() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Task');
    return res;
  }

  //Gets all tasks
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Task");

    List<Task> list = res.isNotEmpty ? res.map((c) => Task.fromJson(c)).toList() : [];
    return list;
  }
}
