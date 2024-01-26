# Tumigo Wallpaper App
```markdown
# Flutter Wallpaper App

A Flutter app for setting wallpapers on mobile devices.

## Features

- Browse a collection of beautiful wallpapers.
- Set wallpapers on your home or lock screen.
- Zoom in and out to preview wallpapers.
- ...

## Screenshots

Include some screenshots or GIFs showcasing your app.

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- ...

### Installing

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/flutter-wallpaper-app.git
   ```

2. Change into the project directory:

   ```bash
   cd flutter-wallpaper-app
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

### Running

Launch the app on an emulator or physical device:

```bash
flutter run
```

## Usage

Explain how users can interact with your app and utilize its features.

## Contributing

If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes.
4. Test your changes thoroughly.
5. Submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- Mention any libraries or tools you used.
- Inspiration.
- ...

```

Replace the placeholders (e.g., `...`) with relevant information about your project. Customize the sections as needed for your app. Add sections like "Acknowledgments" or "License" based on your project's specifics.


```import 'dart:io';

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
    List<Map<String, dynamic>> maps = await db.query(
      'wallpapers',
      orderBy: 'id DESC', // Order by ID in descending order
    );

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
}```