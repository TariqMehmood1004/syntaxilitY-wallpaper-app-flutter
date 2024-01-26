class Wallpaper {
  int id;
  String imageUrl;

  Wallpaper({required this.id, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
    };
  }

  factory Wallpaper.fromMap(Map<String, dynamic> map) {
    return Wallpaper(
      id: map['id'],
      imageUrl: map['imageUrl'],
    );
  }
}
