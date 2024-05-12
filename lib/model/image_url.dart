class ImageUrl {
  final String? imageUrl;

  const ImageUrl({
    this.imageUrl,
  });

  ImageUrl copyWith({
    String? imageUrl,
  }) {
    return ImageUrl(
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  const ImageUrl.empty() : imageUrl = null;

  factory ImageUrl.fromJson(Map<String, dynamic> json) {
    return ImageUrl(
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
      };
}
