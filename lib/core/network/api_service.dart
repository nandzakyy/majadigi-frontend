import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'token_service.dart';

class ApiService {
  final http.Client _client;
  final TokenService _tokenService;

  ApiService([http.Client? client, TokenService? tokenService])
      : _client = client ?? http.Client(),
        _tokenService = tokenService ?? TokenService();

  Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (requireAuth) {
      final token = await _tokenService.getTokenAsync();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<Map<String, dynamic>> _handleResponse(
      http.Response response, String endpointName) async {
    print('\n[ApiService] $endpointName');
    print('[Response] Status: ${response.statusCode}');
    print('[Response] Body: ${response.body}');

    if (response.statusCode == 401) {
      await _tokenService.clearToken();
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['success'] == true) {
        final data = body['data'];
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
        return {};
      }
      final message = body['message']?.toString() ?? 'Request gagal';
      final detail = body['error']?.toString();
      throw Exception(detail != null && detail.isNotEmpty ? '$message ($detail)' : message);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Response parsing failed: $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String? region,
    String? address,
    String? gender,
    String? birthDate,
    String? nik,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/register');
    print('\n[Register] POST $uri');
    print('[Register] Payload: {"email": "$email", "username": "$username"}');

    try {
      final response = await _client.post(
        uri,
        headers: await _getHeaders(),
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone ?? '',
          'region': region ?? '',
          if (address != null && address.isNotEmpty) 'address': address,
          if (gender != null && gender.isNotEmpty) 'gender': gender,
          if (birthDate != null && birthDate.isNotEmpty) 'birthDate': birthDate,
          if (nik != null && nik.isNotEmpty) 'nik': nik,
        }),
      );
      final data = await _handleResponse(response, 'Register');
      final token = data['token'] as String?;
      if (token != null) {
        await _tokenService.setToken(token);
      }
      return data;
    } catch (e) {
      print('[Register Error] $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/login');
    print('\n[Login] POST $uri');
    print('[Login] Payload: {"email": "$email", "password": "***"}');

    try {
      final response = await _client.post(
        uri,
        headers: await _getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = await _handleResponse(response, 'Login');
      final token = data['token'] as String?;
      if (token == null) throw Exception('Token not found in response');
      await _tokenService.setToken(token);
      return data;
    } catch (e) {
      print('[Login Error] $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/users/me');
    final response = await _client.get(uri, headers: await _getHeaders(requireAuth: true));
    return _handleResponse(response, 'Get Profile');
  }

  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> data) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/users/profile');
    print('\n[Update Profile] PUT $uri');
    try {
      final response = await _client.put(
        uri,
        headers: await _getHeaders(requireAuth: true),
        body: jsonEncode(data),
      );
      return _handleResponse(response, 'Update Profile');
    } catch (e) {
      print('[Update Profile Error] $e');
      rethrow;
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/change-password');
    print('\n[Change Password] PUT $uri');
    try {
      final response = await _client.put(
        uri,
        headers: await _getHeaders(requireAuth: true),
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );
      await _handleResponse(response, 'Change Password');
    } catch (e) {
      print('[Change Password Error] $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getCategories() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/categories');
    final response = await _client.get(uri, headers: await _getHeaders(requireAuth: true));
    final data = await _handleResponse(response, 'Get Categories');
    return data['categories'] ?? [];
  }

  Future<List<dynamic>> getHospitals({String? city}) async {
    final uri = Uri.parse(
        '${ApiConfig.baseUrl}/api/hospitals' + (city != null ? '?city=$city' : ''));
    final response = await _client.get(uri, headers: await _getHeaders(requireAuth: true));
    final data = await _handleResponse(response, 'Get Hospitals');
    return data['hospitals'] ?? [];
  }

  Future<Map<String, dynamic>> getHospitalDetail(String id) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/hospitals/$id');
    final response = await _client.get(uri, headers: await _getHeaders(requireAuth: true));
    return _handleResponse(response, 'Get Hospital Detail');
  }

  Future<Map<String, dynamic>> logout() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/logout');
    try {
      final response = await _client.post(uri, headers: await _getHeaders(requireAuth: true));
      await _handleResponse(response, 'Logout');
    } catch (e) {
      print('[Logout Error] $e');
    } finally {
      await _tokenService.clearToken();
    }
    return {};
  }

  Future<bool> healthCheck() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/health');
    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) return false;
      final body = jsonDecode(response.body);
      return body['status'] == 'OK';
    } catch (e) {
      print('[Health Check Error] $e');
      return false;
    }
  }
}
