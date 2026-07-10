class Exhibition {
  final int id;
  final String title;
  final String? description;
  final String? startDate;
  final String? endDate;
  final bool? isCurrent;
  final List<int>? artworkIds;
  final String? apiLink;

  Exhibition({
    required this.id,
    required this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.isCurrent,
    this.artworkIds,
    this.apiLink,
  });

  factory Exhibition.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return Exhibition(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      description: data['description'],
      startDate: data['start_date'],
      endDate: data['end_date'],
      isCurrent: data['is_current'],
      artworkIds: (data['artwork_ids'] as List<dynamic>?)?.cast<int>(),
      apiLink: data['api_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'is_current': isCurrent,
      'artwork_ids': artworkIds,
      'api_link': apiLink,
    };
  }

  @override
  String toString() {
    return 'Exhibition(id: $id, title: $title)';
  }
}
