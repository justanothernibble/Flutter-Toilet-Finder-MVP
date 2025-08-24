class Review {
  final String id;
  final String toiletId;
  final String userId;
  final double rating;
  final String? comment;
  final int? cleanlinessRating;
  final bool? hasPaper;
  final bool? hasSoap;
  final bool? hasTowel;
  final bool? hasHandDryer;
  final bool? isFree;
  final Map<String, dynamic>? additionalData;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.toiletId,
    required this.userId,
    required this.rating,
    this.comment,
    this.cleanlinessRating,
    this.hasPaper,
    this.hasSoap,
    this.hasTowel,
    this.hasHandDryer,
    this.isFree,
    this.additionalData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id']?.toString() ?? '',
      toiletId: map['toilet_id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      rating: _asDouble(map['rating']) ?? 0.0,
      comment: map['comment'] as String?,
      cleanlinessRating: _asInt(map['cleanliness_rating']),
      hasPaper: _asBool(map['has_paper']),
      hasSoap: _asBool(map['has_soap']),
      hasTowel: _asBool(map['has_towel']),
      hasHandDryer: _asBool(map['has_hand_dryer']),
      isFree: _asBool(map['is_free']),
      additionalData: _mapOrNull(map['additional_data']),
      createdAt: _asDate(map['created_at']) ?? DateTime.now(),
      updatedAt: _asDate(map['updated_at']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'toilet_id': toiletId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'cleanliness_rating': cleanlinessRating,
      'has_paper': hasPaper,
      'has_soap': hasSoap,
      'has_towel': hasTowel,
      'has_hand_dryer': hasHandDryer,
      'is_free': isFree,
      'additional_data': additionalData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Helpers (local to avoid cross-file deps)

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
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

Map<String, dynamic>? _mapOrNull(dynamic v) {
  if (v == null) return null;
  if (v is Map) return Map<String, dynamic>.from(v as Map);
  return null;
}
