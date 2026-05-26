import 'package:majadigi/core/theme/api_config.dart';
import 'package:majadigi/core/theme/api_service.dart';

class EmergencyContact {
  final int id;
  final String? region;
  final String title;
  final String phoneNumber;

  EmergencyContact({
    required this.id,
    required this.title,
    required this.phoneNumber,
    this.region,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: (json['id'] ?? 0) is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      region: json['region'],
      title: json['title'] ?? '',
      phoneNumber: json['phone_number'] ?? json['phoneNumber'] ?? '',
    );
  }
}

class EmergencyApi {
  final ApiService _api = ApiService();

  Future<List<String>> getRegions() async {
    final response = await _api.get(ApiConfig.emergencyRegions, authenticated: true);
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is List) {
      return data.map((e) => '$e').toList();
    }
    return const [];
  }

  Future<List<EmergencyContact>> getContacts({String? region}) async {
    final response = await _api.get(ApiConfig.emergencyContacts(region: region), authenticated: true);
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is List) {
      return data.whereType<Map>().map((e) => EmergencyContact.fromJson(e.cast<String, dynamic>())).toList();
    }
    return const [];
  }
}
