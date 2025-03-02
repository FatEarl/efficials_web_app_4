import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('efficials.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE officials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        sports TEXT NOT NULL,
        levels TEXT NOT NULL,
        zipCode TEXT NOT NULL,
        ihsaRegistered INTEGER NOT NULL,
        ihsaRecognized INTEGER NOT NULL,
        ihsaCertified INTEGER NOT NULL,
        yearsExperience INTEGER NOT NULL
      )
    ''');

    await db.insert('officials', {
      'name': 'Mike Johnson',
      'sports': 'Football',
      'levels': 'Underclass,JV',
      'zipCode': '10001',
      'ihsaRegistered': 1,
      'ihsaRecognized': 0,
      'ihsaCertified': 1,
      'yearsExperience': 5,
    });
    await db.insert('officials', {
      'name': 'Jane Smith',
      'sports': 'Basketball',
      'levels': 'Varsity,College',
      'zipCode': '10002',
      'ihsaRegistered': 0,
      'ihsaRecognized': 1,
      'ihsaCertified': 0,
      'yearsExperience': 8,
    });
  }

  Future<List<Map<String, dynamic>>> getOfficials() async {
    final db = await database;
    return await db.query('officials');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
