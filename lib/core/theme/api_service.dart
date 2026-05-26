/// API Service
/// Centralized HTTP client for all API requests with automatic authentication
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';
import 'token_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<Map<String, String>> _getHeaders({bool authenticated = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authenticated) {
      final token = await TokenService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body, bool authenticated = false}) async {
    try {
      final headers = await _getHeaders(authenticated: authenticated);
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      print('🔵 POST $url');
      if (body != null) print('📤 Body: ${jsonEncode(body)}');
      
      final response = await (body == null
              ? http.post(url, headers: headers)
              : http.post(url, headers: headers, body: jsonEncode(body)))
          .timeout(const Duration(milliseconds: ApiConfig.responseTimeout));

      print('📥 Response: ${response.statusCode}');
      print('📦 Body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      print('❌ POST Error: $e');
      throw ApiException('Network error: $e', 0);
    }
  }

  /// GET request
  Future<dynamic> get(String endpoint, {bool authenticated = true}) async {
    try {
      final headers = await _getHeaders(authenticated: authenticated);
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      print('🔵 GET $url');
      
      final response = await http.get(url, headers: headers)
          .timeout(const Duration(milliseconds: ApiConfig.responseTimeout));

      print('📥 Response: ${response.statusCode}');
      print('📦 Body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      print('❌ GET Error: $e');
      throw ApiException('Network error: $e', 0);
    }
  }

  /// PUT request
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body, bool authenticated = true}) async {
    try {
      final headers = await _getHeaders(authenticated: authenticated);
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      print('🔵 PUT $url');
      if (body != null) print('📤 Body: ${jsonEncode(body)}');
      
      final response = await (body == null
              ? http.put(url, headers: headers)
              : http.put(url, headers: headers, body: jsonEncode(body)))
          .timeout(const Duration(milliseconds: ApiConfig.responseTimeout));

      print('📥 Response: ${response.statusCode}');
      print('📦 Body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      print('❌ PUT Error: $e');
      throw ApiException('Network error: $e', 0);
    }
  }

  /// Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    try {
      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.toLowerCase().contains('application/json')) {
        throw ApiException('HTTP ${response.statusCode}: ${response.body}', response.statusCode);
      }

      final body = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      } else {
        final message = body['message'] ?? 'Unknown error occurred';
        throw ApiException(message, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to parse response: ${response.body}', response.statusCode);
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
