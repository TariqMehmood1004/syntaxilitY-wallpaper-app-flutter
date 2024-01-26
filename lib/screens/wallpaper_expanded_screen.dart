// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, sized_box_for_whitespace, unused_import, unnecessary_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class WallpaperExpandedScreen extends StatefulWidget {
  final String imageUrl;
  final int wallpaperId;

  const WallpaperExpandedScreen({
    required this.imageUrl,
    required this.wallpaperId,
  });

  @override
  _WallpaperExpandedScreenState createState() =>
      _WallpaperExpandedScreenState();
}

class _WallpaperExpandedScreenState extends State<WallpaperExpandedScreen> {
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  bool isSetWallpaper = false;

  Future<void> setWallpaper() async {
    try {
      if (isSetWallpaper) {
        // Prompt user to choose Home or Lock screen
        int? selectedLocation = await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Choose wallpaper location'),
              content:
                  const Text('Select where you want to set the wallpaper:'),
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(WallpaperManager.HOME_SCREEN),
                  child: const Text('Home Screen'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(WallpaperManager.LOCK_SCREEN),
                  child: const Text('Lock Screen'),
                ),
              ],
            );
          },
        );

        if (selectedLocation != null) {
          // Fetch the image as bytes
          final Uint8List imageData =
              (await http.get(Uri.parse(widget.imageUrl))).bodyBytes;

          if (Platform.isIOS) {
            // Save the image to a temporary file
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/wallpaper.png');
            await file.writeAsBytes(imageData);

            // Set wallpaper using the saved file path
            await AsyncWallpaper.setWallpaper(
              url: file.path,
            );
          } else {
            final file = File('${widget.imageUrl}.png');
            await file.writeAsBytes(imageData);

            // Set wallpaper using the saved file path
            await WallpaperManager.setWallpaperWithCrop(
                file.path, selectedLocation);
          }
        }
      } else {
        // Set wallpaper using async_wallpaper for iOS
        await AsyncWallpaper.setWallpaper(
          wallpaperLocation: 0,
          url: widget.imageUrl,
        );
      }

      log('Wallpaper set successfully');
    } catch (e) {
      log('Error setting wallpaper: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(0, 166, 133, 133),
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: Center(
          child: GestureDetector(
            onTap: () {
              log("Wallpaper set");
              setState(() {
                isSetWallpaper = !isSetWallpaper;
              });

              // Call the setWallpaper method when the button is tapped
              // setWallpaper();
            },
            child: Container(
              width: 200,
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isSetWallpaper ? Colors.transparent : Colors.black,
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),
                border: Border.all(
                  color: isSetWallpaper
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : Colors.transparent,
                  width: 1.0,
                ),
              ),
              child: const Text(
                'Set as wallpaper',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  fontFamily: 'Poppins',
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'tumigo wallpaper ${widget.wallpaperId}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 16.0,
            fontFamily: 'Poppins',
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.none,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onDoubleTap: () {
          _transformationController.value = Matrix4.identity();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: InteractiveViewer(
            transformationController: _transformationController,
            panEnabled: true,
            minScale: 0.5,
            maxScale: 2.5,
            scaleEnabled: true,
            onInteractionEnd: (details) {
              _transformationController.value = Matrix4.identity();
            },
            onInteractionStart: (details) {
              _transformationController.value = Matrix4.identity();
            },
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
