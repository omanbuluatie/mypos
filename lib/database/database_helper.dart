import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mypos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        pin TEXT,
        role TEXT
      )
    ''');
    // Insert default users
    await db.insert('users', {'username': 'kasir', 'pin': '1111', 'role': 'kasir'});
    await db.insert('users', {'username': 'manager', 'pin': '2222', 'role': 'manager'});
    await db.insert('users', {'username': 'owner', 'pin': '3333', 'role': 'owner'});
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here
  }
}
