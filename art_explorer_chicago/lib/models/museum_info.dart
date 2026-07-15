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

  /// The Art Institute of Chicago's public contact details.
  ///
  /// The AIC public API no longer exposes a dedicated `museum-info` endpoint
  /// (it previously returned this data); the building's address/phone/website
  /// are now sourced from these well-known public values, while operating
  /// hours come from the `/hours` endpoint.
  static const String defaultName = 'Art Institute of Chicago';
  static const String defaultAddress = '111 S Michigan Ave, Chicago, IL 60603';
  static const String defaultPhone = '+1 (312) 443-3600';
  static const String defaultWebsite = 'https://www.artic.edu';

  factory MuseumInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    // Legacy `museum-info` shape used a nested `hours` map.
    Map<String, String>? hours;
    if (data['hours'] != null && data['hours'] is Map) {
      hours = (data['hours'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    } else {
      // New `/hours` shape exposes per-day ISO-8601 duration fields.
      hours = _parseHoursFromRecord(data);
    }

    return MuseumInfo(
      name: data['name'] ?? defaultName,
      address: data['address'] ?? defaultAddress,
      hours: hours,
      phone: data['phone'] ?? defaultPhone,
      email: data['email'],
      website: data['website'] ?? defaultWebsite,
    );
  }

  static Map<String, String>? _parseHoursFromRecord(Map<String, dynamic> data) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    final result = <String, String>{};
    var found = false;
    for (final day in days) {
      final label = day[0].toUpperCase() + day.substring(1);
      final isClosed = data['${day}_is_closed'] == true;
      final openRaw = data['${day}_public_open'];
      final closeRaw = data['${day}_public_close'];
      if (isClosed || openRaw != null || closeRaw != null) found = true;

      if (isClosed) {
        result[label] = 'Closed';
        continue;
      }
      final open = _formatDuration(openRaw);
      final close = _formatDuration(closeRaw);
      if (open != null && close != null) {
        result[label] = '$open – $close';
      } else {
        result[label] = 'Hours unavailable';
      }
    }

    return found ? result : null;
  }

  static String? _formatDuration(dynamic value) {
    if (value == null || value is! String) return null;
    // ISO-8601 duration, e.g. "PT11H00M" -> 11:00 AM, "PT20H00M" -> 8:00 PM.
    final match = RegExp(r'PT(\d+)H(?:(\d+)M)?').firstMatch(value);
    if (match == null) return null;
    var hour = int.parse(match.group(1)!);
    final minute = match.group(2) != null ? int.parse(match.group(2)!) : 0;
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute == 0 ? '' : ':${minute.toString().padLeft(2, '0')}';
    return '$displayHour$minuteStr $ampm';
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
