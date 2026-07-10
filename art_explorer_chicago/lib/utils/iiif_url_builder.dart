class IiifUrlBuilder {
  static const String _baseUrl = 'https://www.artic.edu/iiif/2';

  static String buildImageUrl(
    String imageId, {
    int width = 843,
    int? height,
    String region = 'full',
    String rotation = '0',
    String quality = 'default',
    String format = 'jpg',
  }) {
    final size = height != null ? '$width,$height' : '$width,';
    return '$_baseUrl/$imageId/$region/$size/$rotation/$quality.$format';
  }

  static String buildThumbnailUrl(String imageId, {int size = 400}) {
    return buildImageUrl(imageId, width: size);
  }

  static String buildHighResUrl(String imageId) {
    return buildImageUrl(imageId, width: 1686);
  }
}
