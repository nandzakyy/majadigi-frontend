import 'package:shared_preferences/shared_preferences.dart';

/// Shared token store — single instance so every [ApiService] reads the same token.
class TokenService {
  static final TokenService _instance = TokenService._();
  factory TokenService() => _instance;
  TokenService._();

  static const String _tokenKey = 'majadigi_auth_token';

  SharedPreferences? _prefs;
  String? _memoryToken;
  Future<void>? _initFuture;

  Future<void> _ensureInitialized() async {
    _initFuture ??= _loadFromDisk();
    await _initFuture;
  }

  Future<void> _loadFromDisk() async {
    _prefs = await SharedPreferences.getInstance();
    _memoryToken ??= _prefs!.getString(_tokenKey);
  }

  Future<void> setToken(String token) async {
    await _ensureInitialized();
    _memoryToken = token;
    await _prefs!.setString(_tokenKey, token);
    print('[TokenService] Token saved');
  }

  /// Returns cached token; call [ensureReady] first if the app just started.
  String? getToken() => _memoryToken;

  Future<String?> getTokenAsync() async {
    await _ensureInitialized();
    return _memoryToken;
  }

  Future<void> ensureReady() => _ensureInitialized();

  Future<void> clearToken() async {
    await _ensureInitialized();
    _memoryToken = null;
    await _prefs!.remove(_tokenKey);
    print('[TokenService] Token cleared');
  }

  Future<bool> hasToken() async {
    await _ensureInitialized();
    return _memoryToken != null && _memoryToken!.isNotEmpty;
  }
}
