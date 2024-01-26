import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/unsplash_image_api_model.dart'; // Adjust the import path based on your project structure

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<ImageModel> _latestWallpapers = [];

  @override
  void initState() {
    super.initState();
    _fetchLatestWallpapers();
  }

  Future<void> _fetchLatestWallpapers() async {
    const apiUrl =
        'https://api.unsplash.com/photos/?client_id=XC6ZUqeqiMmA__rKaH9UT3cwjg_cc3neuzz_dJhGICM';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<ImageModel> wallpapers =
      jsonData.map((e) => ImageModel.fromJson(e)).toList();

      setState(() {
        _latestWallpapers = wallpapers;
      });
    } else {
      // Handle error
      debugPrint('Error fetching latest wallpapers: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Latest Wallpapers'),
              background: _latestWallpapers.isNotEmpty
                  ? Image.network(
                _latestWallpapers[0].urls.full,
                fit: BoxFit.cover,
              )
                  : Image.network(
                'https://example.com/placeholder.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final ImageModel wallpaper = _latestWallpapers[index];

                return ListTile(
                  title: Text(wallpaper.altDescription),
                  subtitle: Text('by ${wallpaper.description}'),
                  onTap: () {
                    // Handle wallpaper tap
                  },
                );
              },
              childCount: _latestWallpapers.length,
            ),
          ),
        ],
      ),
    );
  }
}
