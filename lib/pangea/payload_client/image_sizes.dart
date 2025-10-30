class ImageSizes {
  final ImageSize? thumbnail;
  final ImageSize? medium;
  final ImageSize? large;

  const ImageSizes({
    this.thumbnail,
    this.medium,
    this.large,
  });

  factory ImageSizes.fromJson(Map<String, dynamic> json) {
    return ImageSizes(
      thumbnail: json['thumbnail'] != null
          ? ImageSize.fromJson(json['thumbnail'])
          : null,
      medium:
          json['medium'] != null ? ImageSize.fromJson(json['medium']) : null,
      large: json['large'] != null ? ImageSize.fromJson(json['large']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail?.toJson(),
      'medium': medium?.toJson(),
      'large': large?.toJson(),
    };
  }
}

class ImageSize {
  final String? url;
  final int? width;
  final int? height;
  final String? mimeType;
  final int? filesize;
  final String? filename;

  const ImageSize({
    this.url,
    this.width,
    this.height,
    this.mimeType,
    this.filesize,
    this.filename,
  });

  factory ImageSize.fromJson(Map<String, dynamic> json) {
    return ImageSize(
      url: json['url'],
      width: json['width'],
      height: json['height'],
      mimeType: json['mimeType'],
      filesize: json['filesize'],
      filename: json['filename'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'width': width,
      'height': height,
      'mimeType': mimeType,
      'filesize': filesize,
      'filename': filename,
    };
  }
}
