import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'your_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        path TEXT
      )
    ''');
  }

  Future<int> insertImage(String title, String description, String imagePath) async {
    final db = await database;
    return await db.insert('images', {'title': title, 'description': description, 'path': imagePath});
  }

  Future<List<Map<String, dynamic>>> getImages() async {
    final db = await database;
    return await db.query('images');
  }

  Future<int> updateImage(int id, String title, String description, String newPath) async {
    final db = await database;
    return await db.update('images', {'title': title, 'description': description, 'path': newPath},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteImage(int id) async {
    final db = await database;
    return await db.delete('images', where: 'id = ?', whereArgs: [id]);
  }
}