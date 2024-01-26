import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syntaxity_wallpaper/Models/wallpaper_model.dart';

class WallpaperDatabaseHelper {
  static final WallpaperDatabaseHelper _instance =
      WallpaperDatabaseHelper._private();

  WallpaperDatabaseHelper._private();

  factory WallpaperDatabaseHelper() => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'wallpapers.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE wallpapers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageUrl TEXT
      )
    ''');
  }

  Future<int> insertWallpaper(Wallpaper wallpaper) async {
    Database db = await database;
    return await db.insert('wallpapers', wallpaper.toMap());
  }

  Future<List<Wallpaper>> getWallpapers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('wallpapers');

    return List.generate(maps.length, (i) {
      return Wallpaper.fromMap(maps[i]);
    });
  }

  Future<int> deleteWallpaper(int id) async {
    Database db = await database;
    return await db.delete('wallpapers', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateWallpaper(Wallpaper wallpaper) async {
    Database db = await database;
    return await db.update(
      'wallpapers',
      wallpaper.toMap(),
      where: 'id = ?',
      whereArgs: [wallpaper.id],
    );
  }

  Future<int> deleteAllWallpapers() async {
    Database db = await database;
    return await db.delete('wallpapers');
  }

  Future close() async {
    Database db = await database;
    db.close();
  }
}
