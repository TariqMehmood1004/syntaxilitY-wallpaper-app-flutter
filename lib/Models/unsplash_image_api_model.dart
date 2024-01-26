class ImageModel {
  String id;
  String slug;
  String createdAt;
  String updatedAt;
  DateTime? promotedAt;
  int width;
  int height;
  String color;
  String blurHash;
  String description;
  String altDescription;
  List<String> breadcrumbs;
  UrlsModel urls;

  ImageModel({
    required this.id,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    this.promotedAt,
    required this.width,
    required this.height,
    required this.color,
    required this.blurHash,
    required this.description,
    required this.altDescription,
    required this.breadcrumbs,
    required this.urls,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      promotedAt: json['promoted_at'] != null
          ? DateTime.parse(json['promoted_at'])
          : null,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      color: json['color'] ?? '',
      blurHash: json['blur_hash'] ?? '',
      description: json['description'] ?? '',
      altDescription: json['alt_description'] ?? '',
      breadcrumbs: List<String>.from(json['breadcrumbs'] ?? []),
      urls: UrlsModel.fromJson(json['urls'] ?? {}),
    );
  }
}

class UrlsModel {
  String raw;
  String full;
  String regular;
  String small;
  String thumb;
  String smallS3;

  UrlsModel({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
    required this.smallS3,
  });

  factory UrlsModel.fromJson(Map<String, dynamic> json) {
    return UrlsModel(
      raw: json['raw'] ?? '',
      full: json['full'] ?? '',
      regular: json['regular'] ?? '',
      small: json['small'] ?? '',
      thumb: json['thumb'] ?? '',
      smallS3: json['small_s3'] ?? '',
    );
  }
}
