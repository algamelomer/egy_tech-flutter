import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize FFI for non-mobile platforms
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Get the path for the database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "auth.db");

    // Open the database
    return await openDatabase(
      path,
      version: 2, // Incremented version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Tokens (
        token TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE Themes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        themeMode TEXT NOT NULL,
        backgroundColor INTEGER,
        primaryColor INTEGER,
        secondaryColor INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE Themes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          themeMode TEXT NOT NULL,
          backgroundColor INTEGER,
          primaryColor INTEGER,
          secondaryColor INTEGER
        )
      ''');
    }
  }

  // Token methods
  Future<void> saveToken(String token) async {
    final db = await database;
    await db.insert(
      'Tokens',
      {'token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getToken() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('Tokens', limit: 1);
    return results.isNotEmpty ? results.first['token'] as String? : null;
  }

  Future<void> deleteToken() async {
    final db = await database;
    await db.delete('Tokens');
  }

  // Theme methods
Future<void> saveTheme({
  required String themeMode,
  int? backgroundColor,
  int? primaryColor,
  int? secondaryColor,
}) async {
  final db = await database;
  // Clear existing themes before saving new one
  await db.delete('Themes');
  await db.insert(
    'Themes',
    {
      'themeMode': themeMode,
      'backgroundColor': backgroundColor,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    },
  );
}

  Future<Map<String, dynamic>?> getTheme() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('Themes', limit: 1);
    print('Loaded theme: $results');
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> deleteTheme() async {
    final db = await database;
    await db.delete('Themes');
  }
}