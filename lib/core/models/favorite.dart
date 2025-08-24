class Favorite {
  final String userId;
  final String toiletId;
  final DateTime createdAt;

  Favorite({
    required this.userId,
    required this.toiletId,
    required this.createdAt,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      userId: map['user_id']?.toString() ?? '',
      toiletId: map['toilet_id']?.toString() ?? '',
      createdAt: _asDate(map['created_at']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'toilet_id': toiletId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

DateTime? _asDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}
