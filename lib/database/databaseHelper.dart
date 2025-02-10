import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'app_planes.db');

    return await openDatabase(
      path,
      version: 2, // Incrementa la versión de la base de datos
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> recreatePlanAlimenticioTable() async {
    final db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS plan_alimenticio (
        id INTEGER PRIMARY KEY,
        userId TEXT,
        desayuno TEXT,
        merienda1 TEXT,
        almuerzo TEXT,
        cena TEXT
      )
    ''');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plan_alimenticio (
        id INTEGER PRIMARY KEY,
        userId TEXT,
        desayuno TEXT,
        merienda1 TEXT,
        almuerzo TEXT,
        cena TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE plan_alimenticio ADD COLUMN userId TEXT');
    }
  }

  Future<void> insertPlanAlimenticio(
      String userId, PlanAlimenticioModel plan) async {
    final db = await database;
    await db.insert(
      'plan_alimenticio',
      {
        'userId': userId,
        ...plan.toJson(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PlanAlimenticioModel?> getPlanAlimenticio(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plan_alimenticio',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return PlanAlimenticioModel.fromJson(maps.first);
    }
    return null;
  }

  Future<int> countPlans() async {
    final db = await database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM plan_alimenticio')) ??
        0;
  }

  Future<void> clearDatabase() async {
    final db = await database;
    final tables = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    for (var table in tables) {
      if (table['name'] != 'android_metadata' &&
          table['name'] != 'sqlite_sequence') {
        await db.execute('DROP TABLE IF EXISTS ${table['name']}');
      }
    }
  }
}
