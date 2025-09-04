// latlong2 removed: model now exposes primitive doubles only for coordinates.

/// Enum mapping for the database enum `public.toilet_type`.
/// Keep string values in sync with the DB.
enum ToiletType { public, cafe, restaurant, park, mall, station, other }

ToiletType toiletTypeFromString(String? value) {
  switch (value) {
    case 'public':
      return ToiletType.public;
    case 'cafe':
      return ToiletType.cafe;
    case 'restaurant':
      return ToiletType.restaurant;
    case 'park':
      return ToiletType.park;
    case 'mall':
      return ToiletType.mall;
    case 'station':
      return ToiletType.station;
    case 'other':
    default:
      return ToiletType.other;
  }
}

String toiletTypeToString(ToiletType type) {
  switch (type) {
    case ToiletType.public:
      return 'public';
    case ToiletType.cafe:
      return 'cafe';
    case ToiletType.restaurant:
      return 'restaurant';
    case ToiletType.park:
      return 'park';
    case ToiletType.mall:
      return 'mall';
    case ToiletType.station:
      return 'station';
    case ToiletType.other:
      return 'other';
  }
}

/// Client-side representation of a Toilet row.
/// - `location` in DB is PostGIS geometry/geography(Point,4326).
///   We accept multiple wire formats (GeoJSON/WKT) and expose LatLng helpers.
class Toilet {
  final String id;
  final String name;
  final String? description;

  /// Raw location as returned by PostgREST (could be GeoJSON Map or WKT String)
  final dynamic locationRaw;

  /// Preferred wire format fields when provided by API/view
  final double? lat;
  final double? lng;

  final ToiletType type;
  final String? address;
  final bool isVerified;
  final bool isOperational;
  final bool isAccessible;
  final List<String> accessibilityFeatures;
  final Map<String, dynamic>? operatingHours;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final DateTime? lastVerifiedAt;

  Toilet({
    required this.id,
    required this.name,
    this.description,
    this.locationRaw,
    this.lat,
    this.lng,
    required this.type,
    this.address,
    this.isVerified = false,
    this.isOperational = true,
    this.isAccessible = false,
    this.accessibilityFeatures = const [],
    this.operatingHours,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.lastVerifiedAt,
  });

  /// Returns coordinates from either explicit lat/lng fields or by parsing locationRaw.
  _LatLngPair? _computeLatLng() {
    // 1) Preferred fields supplied by API/view
    if (lat != null && lng != null) {
      return _LatLngPair(lat!, lng!);
    }

    if (locationRaw == null) return null;

    // 2) GeoJSON Point { type: 'Point', coordinates: [lng, lat] }
    if (locationRaw is Map) {
      final map = Map<String, dynamic>.from(locationRaw as Map);
      final type = map['type'];
      final coords = map['coordinates'];
      if (type == 'Point' && coords is List && coords.length >= 2) {
        final lngVal = _asDouble(coords[0]);
        final latVal = _asDouble(coords[1]);
        if (latVal != null && lngVal != null) {
          return _LatLngPair(latVal, lngVal);
        }
      }
    }

    // 3) WKT string: POINT(lng lat)
    if (locationRaw is String) {
      final wkt = locationRaw as String;
      final match = RegExp(
        r'POINT\\s*\\(([-0-9.]+)\\s+([-0-9.]+)\\)',
      ).firstMatch(wkt.toUpperCase());
      if (match != null && match.groupCount == 2) {
        final lngVal = double.tryParse(match.group(1)!);
        final latVal = double.tryParse(match.group(2)!);
        if (latVal != null && lngVal != null) {
          return _LatLngPair(latVal, lngVal);
        }
      }
    }

    return null;
  }

  double? get latitude => lat ?? _computeLatLng()?.lat;
  double? get longitude => lng ?? _computeLatLng()?.lng;

  factory Toilet.fromMap(Map<String, dynamic> map) {
    return Toilet(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description'] as String?,
      locationRaw: map['location'],
      lat: _asDouble(map['lat']),
      lng: _asDouble(map['lng']),
      type: toiletTypeFromString(map['type']?.toString()),
      address: map['address'] as String?,
      isVerified: _asBool(map['is_verified']) ?? false,
      isOperational: _asBool(map['is_operational']) ?? true,
      isAccessible: _asBool(map['is_accessible']) ?? false,
      accessibilityFeatures: _stringList(map['accessibility_features']),
      operatingHours: _mapOrNull(map['operating_hours']),
      createdAt: _asDate(map['created_at']) ?? DateTime.now(),
      updatedAt: _asDate(map['updated_at']) ?? DateTime.now(),
      createdBy: map['created_by']?.toString(),
      lastVerifiedAt: _asDate(map['last_verified_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      // Preferred wire format
      'lat': lat,
      'lng': lng,
      // Fallback raw location (GeoJSON/WKT)
      'location': locationRaw,
      'type': toiletTypeToString(type),
      'address': address,
      'is_verified': isVerified,
      'is_operational': isOperational,
      'is_accessible': isAccessible,
      'accessibility_features': accessibilityFeatures,
      'operating_hours': operatingHours,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'last_verified_at': lastVerifiedAt?.toIso8601String(),
    };
  }
}

// Helpers

class _LatLngPair {
  final double lat;
  final double lng;
  const _LatLngPair(this.lat, this.lng);
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is num) return v != 0;
  final s = v.toString().toLowerCase();
  if (s == 'true') return true;
  if (s == 'false') return false;
  return null;
}

DateTime? _asDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}

List<String> _stringList(dynamic v) {
  if (v == null) return const [];
  if (v is List) {
    return v
        .map((e) => e?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }
  return const [];
}

Map<String, dynamic>? _mapOrNull(dynamic v) {
  if (v == null) return null;
  if (v is Map) return Map<String, dynamic>.from(v as Map);
  return null;
}
