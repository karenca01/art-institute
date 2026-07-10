class MuseumInfo {
  final String name;
  final String? address;
  final Map<String, String>? hours;
  final String? phone;
  final String? email;
  final String? website;

  MuseumInfo({
    required this.name,
    this.address,
    this.hours,
    this.phone,
    this.email,
    this.website,
  });

  factory MuseumInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final hoursMap = <String, String>{};
    
    if (data['hours'] != null && data['hours'] is Map) {
      (data['hours'] as Map<String, dynamic>).forEach((key, value) {
        hoursMap[key] = value.toString();
      });
    }

    return MuseumInfo(
      name: data['name'] ?? 'Art Institute of Chicago',
      address: data['address'],
      hours: hoursMap.isNotEmpty ? hoursMap : null,
      phone: data['phone'],
      email: data['email'],
      website: data['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'hours': hours,
      'phone': phone,
      'email': email,
      'website': website,
    };
  }

  @override
  String toString() {
    return 'MuseumInfo(name: $name)';
  }
}
