// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:syntaxity_wallpaper/Helpers/wallpaper_database_helpers.dart';
import 'package:syntaxity_wallpaper/Models/wallpaper_model.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final WallpaperDatabaseHelper _databaseHelper = WallpaperDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpapers'),
      ),
      body: FutureBuilder(
        future: _databaseHelper.getWallpapers(),
        builder: (context, AsyncSnapshot<List<Wallpaper>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No wallpapers available.');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Image.network(snapshot.data![index].imageUrl),
                );
              },
            );
          }
        },
      ),
    );
  }
}
