import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static Database? _database;
  final String tableName = 'images';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final pathToDatabase = path.join(dbPath, 'your_database.db');

    return await openDatabase(
      pathToDatabase,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            image_path TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertImage(String imagePath) async {
    final db = await database;
    return await db.insert(tableName, {'image_path': imagePath});
  }

  Future<void> deleteImage(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateImage(int id, String imagePath) async {
    final db = await database;
    await db.update(tableName, {'image_path': imagePath},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllImages() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>> getImageById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      throw Exception('Image not found');
    }
  }
}
