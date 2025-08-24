import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/toilet.dart';
import '../services/supabase_service.dart';

abstract class ToiletRepository {
  Future<List<Toilet>> fetchAll();
  Future<Toilet?> getById(String id);
  Future<Toilet> createToilet({
    required String name,
    String? description,
    required double lat,
    required double lng,
    ToiletType type,
    String? address,
    bool isAccessible,
    List<String>? accessibilityFeatures,
    Map<String, dynamic>? operatingHours,
  });
  Future<Toilet> updateToilet({
    required String id,
    String? name,
    String? description,
    double? lat,
    double? lng,
    ToiletType? type,
    String? address,
    bool? isAccessible,
    List<String>? accessibilityFeatures,
    Map<String, dynamic>? operatingHours,
  });
}

class SupabaseToiletRepository implements ToiletRepository {
  SupabaseToiletRepository(this._supabaseService);
  final SupabaseService _supabaseService;

  SupabaseClient get _client => _supabaseService.client;

  String toiletTypeToString(ToiletType type) {
    return type.toString().split('.').last;
  }

  @override
  Future<List<Toilet>> fetchAll() async {
    final data = await _client.from('v_toilets_public').select('*');
    return (data as List)
        .map((e) => Toilet.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<Toilet?> getById(String id) async {
    final data = await _client
        .from('v_toilets_public')
        .select('*')
        .eq('id', id)
        .maybeSingle();
    if (data == null) return null;
    return Toilet.fromMap(Map<String, dynamic>.from(data));
  }

  @override
  Future<Toilet> createToilet({
    required String name,
    String? description,
    required double lat,
    required double lng,
    ToiletType type = ToiletType.public,
    String? address,
    bool isAccessible = false,
    List<String>? accessibilityFeatures,
    Map<String, dynamic>? operatingHours,
  }) async {
    final res = await _client.rpc(
      'fn_create_toilet',
      params: {
        'p_name': name,
        'p_description': description,
        'p_lat': lat,
        'p_lng': lng,
        'p_type': toiletTypeToString(type),
        'p_address': address,
        'p_is_accessible': isAccessible,
        'p_accessibility_features': accessibilityFeatures,
        'p_operating_hours': operatingHours,
      },
    );
    return Toilet.fromMap(Map<String, dynamic>.from(res));
  }

  @override
  Future<Toilet> updateToilet({
    required String id,
    String? name,
    String? description,
    double? lat,
    double? lng,
    ToiletType? type,
    String? address,
    bool? isAccessible,
    List<String>? accessibilityFeatures,
    Map<String, dynamic>? operatingHours,
  }) async {
    final res = await _client.rpc(
      'fn_update_toilet',
      params: {
        'p_id': id,
        'p_name': name,
        'p_description': description,
        'p_lat': lat,
        'p_lng': lng,
        'p_type': type != null ? toiletTypeToString(type) : null,
        'p_address': address,
        'p_is_accessible': isAccessible,
        'p_accessibility_features': accessibilityFeatures,
        'p_operating_hours': operatingHours,
      },
    );
    return Toilet.fromMap(Map<String, dynamic>.from(res));
  }
}
