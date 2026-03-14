// ignore_for_file: await_only_futures
import 'dart:io' as io;

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:yemek_tarifi_app/core/logging/app_logger.dart';

import 'food_application_database.dart';

class DBHelper {
  DBHelper();

  static Database? globalDataBase;
  Future<Database?> get db async {
    if (globalDataBase != null) {
      return globalDataBase;
    }
    globalDataBase = await initDatabase();
    return globalDataBase;
  }

  Future<Database?>? initDatabase() async {
    try {
      const String fileName = 'foodappdatabase23.db';
      final io.Directory documentDirectory =
          await getApplicationDocumentsDirectory();
      final String path = join(documentDirectory.path, fileName);
      final Database db = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) {},
      );
      return db;
    } catch (e) {
      AppLogger.e('Database initialization failed', e);
      return null;
    }
  }

  /// Creates the database table with `Favorites` column
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE foodAppTable(
        Ver INTEGER NOT NULL PRIMARY KEY,
        LanguageCode INTEGER NOT NULL,
        InitialIngredients TEXT NOT NULL,
        Favorites TEXT NOT NULL
      )
    ''');
  }

  /// Inserts or updates a `FoodApplicationDatabase` entry
  Future<void> add(FoodApplicationDatabase column) async {
    try {
      final Database? dbClient = await db;
      await dbClient!.insert(
        'foodAppTable',
        column.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      AppLogger.e('Database insert failed', e);
    }
  }

  /// Retrieves a `FoodApplicationDatabase` entry by version number
  Future<FoodApplicationDatabase?> getList(int ver) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query(
      'foodAppTable',
      columns: ['Ver', 'LanguageCode', 'InitialIngredients', 'Favorites'],
      where: 'Ver = ?',
      whereArgs: [ver],
    );

    if (maps.isNotEmpty) {
      return FoodApplicationDatabase.fromMap(maps.first);
    }
    return null;
  }

  /// Updates an existing `FoodApplicationDatabase` entry
  Future<int> update(FoodApplicationDatabase column) async {
    var dbClient = await db;
    return await dbClient!.update(
      'foodAppTable',
      column.toMap(),
      where: 'Ver = ?',
      whereArgs: [column.ver],
    );
  }

  /// Deletes an entry from the database
  Future<int> delete(FoodApplicationDatabase column) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'foodAppTable',
      where: 'Ver = ?',
      whereArgs: [column.ver],
    );
  }

  /// Closes the database connection
  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }
}
