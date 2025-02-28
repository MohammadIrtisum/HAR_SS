import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'labels.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE labels (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE
          )
        ''');
      },
    );
  }

  Future<void> insertLabel(String name) async {
    final db = await database;
    await db.insert(
      'labels',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.ignore, // Prevent duplicates
    );
  }

  Future<List<Map<String, dynamic>>> getLabels() async {
    final db = await database;
    return await db.query('labels');
  }

  Future<void> deleteLabel(int id) async {
    final db = await database;
    await db.delete('labels', where: 'id = ?', whereArgs: [id]);
  }
}
