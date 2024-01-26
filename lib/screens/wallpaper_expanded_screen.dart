// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, sized_box_for_whitespace

import 'dart:developer';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

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

  // Method to set wallpaper
  Future<void> setWallpaper() async {
    try {
      if (isSetWallpaper) {
        int location = WallpaperManager.BOTH_SCREEN; //can be Home/Lock Screen
        bool result = await WallpaperManager.setWallpaperFromFile(
            widget.imageUrl, location);
        if (result) {
          log('Wallpaper set successfully');
        } else {
          log('Error setting wallpaper');
        }
      } else {
        // Set wallpaper using async_wallpaper for iOS
        await AsyncWallpaper.setWallpaper(
            wallpaperLocation: 0, url: widget.imageUrl);
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
              setWallpaper();
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
