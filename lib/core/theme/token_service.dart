/// Token Storage Service
/// Handles JWT token persistence using SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'jwt_token';
  static const String _userDataKey = 'user_data';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userPhoneKey = 'user_phone';
  
  /// Save JWT token to local storage
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  
  /// Get JWT token from local storage
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  /// Clear token and all user data
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userPhoneKey);
  }
  
  /// Check if token exists
  static Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  /// Save user data
  static Future<void> saveUserData({
    required int id,
    required String email,
    required String username,
    String? phone,
    String? fullName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, id);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, username);
    if (phone != null) await prefs.setString(_userPhoneKey, phone);
    if (fullName != null) await prefs.setString('user_full_name', fullName);
  }

  /// Get saved user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_userIdKey);
    final email = prefs.getString(_userEmailKey);
    
    if (id == null || email == null) return null;
    
    return {
      'id': id,
      'email': email,
      'username': prefs.getString(_userNameKey),
      'phone': prefs.getString(_userPhoneKey),
      'fullName': prefs.getString('user_full_name'),
    };
  }
}
