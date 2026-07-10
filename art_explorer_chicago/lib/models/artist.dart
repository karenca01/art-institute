class Artist {
  final int id;
  final String title;
  final int? birthDate;
  final int? deathDate;
  final String? nationality;
  final String? biography;
  final String? apiLink;

  Artist({
    required this.id,
    required this.title,
    this.birthDate,
    this.deathDate,
    this.nationality,
    this.biography,
    this.apiLink,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return Artist(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      birthDate: data['birth_date'],
      deathDate: data['death_date'],
      nationality: data['nationality'],
      biography: data['biography'],
      apiLink: data['api_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'birth_date': birthDate,
      'death_date': deathDate,
      'nationality': nationality,
      'biography': biography,
      'api_link': apiLink,
    };
  }

  @override
  String toString() {
    return 'Artist(id: $id, title: $title)';
  }
}
