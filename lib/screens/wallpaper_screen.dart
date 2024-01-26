// ignore_for_file: use_super_parameters, library_private_types_in_public_api, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_cast, depend_on_referenced_packages

import 'dart:io';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syntaxity_wallpaper/Helpers/wallpaper_database_helpers.dart';
import 'package:syntaxity_wallpaper/Models/wallpaper_model.dart';
import 'package:syntaxity_wallpaper/screens/wallpaper_expanded_screen.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({Key? key}) : super(key: key);

  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final WallpaperDatabaseHelper _databaseHelper = WallpaperDatabaseHelper();

  @override
  void initState() {
    super.initState();
    insertWallpapers();
  }

  @override
  void dispose() {
    _databaseHelper.close();
    super.dispose();
  }

  Future<void> insertWallpapers() async {
    List<String> wallpaperUrls = [
      'https://images.unsplash.com/photo-1615572766543-06c21416eb05?q=80&w=3327&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1623183073860-70eacab1bca4?q=80&w=3121&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1540979388789-6cee28a1cdc9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1540979388789-6cee28a1cdc9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1555093596-009b0f066b96?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjN8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1604903256031-4328f723fa33?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mjd8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1503249023995-51b0f3778ccf?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mjh8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1503756234508-e32369269deb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzF8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1612713566476-385f5af81095?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzJ8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzR8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1626081708119-99cb0eff1f4c?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzl8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1613226505855-999302e0c08d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDN8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1474767821094-a8fe9d8c8fdd?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDh8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1512850183-6d7990f42385?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTB8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1549241520-425e3dfc01cb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTJ8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1550100136-e092101726f4?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTZ8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1560759226-14da22a643ef?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTl8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1553634551-6d1e9f22afee?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjJ8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1559291001-693fb9166cba?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1536152470836-b943b246224c?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjR8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1538970272646-f61fabb3a8a2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzF8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1527769929977-c341ee9f2033?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzZ8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1504893524553-b855bce32c67?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzR8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1576502200916-3808e07386a5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nzh8fGZ1bGwlMjBoZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHx8MA%3D%3D',
    ];

    for (int i = 0; i < wallpaperUrls.length; i++) {
      Wallpaper wallpaper = Wallpaper(
        id: i + 1,
        imageUrl: wallpaperUrls[i],
      );

      // Insert each wallpaper into the database
      await _databaseHelper.insertWallpaper(wallpaper);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Save the picked image to the database
      await _saveImageToDatabase(pickedFile.path);
    }
  }

  Future<void> _saveImageToDatabase(String imagePath) async {
    // Generate the integer random id for the wallpaper
    Random random = Random();
    int randomId = random.nextInt(1000000);

    // Check if the image path is a local file path
    if (imagePath.startsWith('file://')) {
      // For local file paths, store the path directly
      Wallpaper wallpaper = Wallpaper(imageUrl: imagePath, id: randomId);
      await _databaseHelper.insertWallpaper(wallpaper);
    } else {
      // For other cases, save the image to a temporary file and store its path
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/$randomId.jpg';

      // Copy the image to the temporary path
      File(imagePath).copySync(tempPath);

      Wallpaper wallpaper = Wallpaper(imageUrl: tempPath, id: randomId);
      await _databaseHelper.insertWallpaper(wallpaper);
    }

    // Show Flutter toast message
    Fluttertoast.showToast(
      msg: 'Image inserted successfully!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Refresh the list by calling setState
    setState(() {});
    await _databaseHelper.getWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('tumigo Wallpapers'),
      ),
      extendBody: true,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: () {
          setState(() {
            _pickImage();
            _databaseHelper.getWallpapers();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () {
          return _databaseHelper.getWallpapers();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        child: FutureBuilder(
                          future: _databaseHelper.getWallpapers(),
                          builder: (context,
                              AsyncSnapshot<List<Wallpaper>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text('No wallpapers available.');
                            } else {
                              // Filter to get the top 5 wallpapers
                              List<Wallpaper> top5Wallpapers =
                                  snapshot.data!.take(5).toList();

                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisExtent: 300,
                                  mainAxisSpacing: 0,
                                ),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: top5Wallpapers.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WallpaperExpandedScreen(
                                            imageUrl:
                                                top5Wallpapers[index].imageUrl,
                                            wallpaperId: top5Wallpapers[index]
                                                .id, // Pass the wallpaper ID
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image(
                                          image: top5Wallpapers[index]
                                                  .imageUrl
                                                  .startsWith('http')
                                              ? NetworkImage(
                                                      top5Wallpapers[index]
                                                          .imageUrl)
                                                  as ImageProvider<Object>
                                              : FileImage(File(
                                                      top5Wallpapers[index]
                                                          .imageUrl))
                                                  as ImageProvider<Object>,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Second Container with GridView
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: FutureBuilder(
                    future: _databaseHelper.getWallpapers(),
                    builder:
                        (context, AsyncSnapshot<List<Wallpaper>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No wallpapers available.');
                      } else {
                        return GridView.builder(
                          // Adjusted to make it take only the space it needs
                          padding: const EdgeInsets.all(8.0),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                            childAspectRatio: 1.0,
                            mainAxisExtent: 200.0,
                          ),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WallpaperExpandedScreen(
                                      imageUrl: snapshot.data![index].imageUrl,
                                      wallpaperId: snapshot.data![index]
                                          .id, // Pass the wallpaper ID
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image(
                                  image: snapshot.data![index].imageUrl
                                          .startsWith('http')
                                      ? NetworkImage(
                                              snapshot.data![index].imageUrl)
                                          as ImageProvider<Object>
                                      : FileImage(
                                          File(
                                            snapshot.data![index].imageUrl,
                                          ),
                                        ) as ImageProvider<Object>,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
