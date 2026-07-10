class Artwork {
  final int id;
  final String title;
  final String? artistTitle;
  final int? artistId;
  final String? dateDisplay;
  final int? dateStart;
  final int? dateEnd;
  final String? medium;
  final String? dimensions;
  final String? description;
  final String? imageId;
  final String? creditLine;
  final bool? isPublicDomain;
  final String? departmentTitle;
  final String? apiLink;

  Artwork({
    required this.id,
    required this.title,
    this.artistTitle,
    this.artistId,
    this.dateDisplay,
    this.dateStart,
    this.dateEnd,
    this.medium,
    this.dimensions,
    this.description,
    this.imageId,
    this.creditLine,
    this.isPublicDomain,
    this.departmentTitle,
    this.apiLink,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return Artwork(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      artistTitle: data['artist_title'],
      artistId: data['artist_id'],
      dateDisplay: data['date_display'],
      dateStart: data['date_start'],
      dateEnd: data['date_end'],
      medium: data['medium_display'],
      dimensions: data['dimensions'],
      description: data['description'],
      imageId: data['image_id'],
      creditLine: data['credit_line'],
      isPublicDomain: data['is_public_domain'],
      departmentTitle: data['department_title'],
      apiLink: data['api_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist_title': artistTitle,
      'artist_id': artistId,
      'date_display': dateDisplay,
      'date_start': dateStart,
      'date_end': dateEnd,
      'medium_display': medium,
      'dimensions': dimensions,
      'description': description,
      'image_id': imageId,
      'credit_line': creditLine,
      'is_public_domain': isPublicDomain,
      'department_title': departmentTitle,
      'api_link': apiLink,
    };
  }

  @override
  String toString() {
    return 'Artwork(id: $id, title: $title, artist: $artistTitle)';
  }
}
