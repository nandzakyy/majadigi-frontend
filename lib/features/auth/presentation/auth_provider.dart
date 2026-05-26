import 'package:flutter/material.dart';
import 'package:majadigi/core/theme/api_service.dart';
import 'package:majadigi/core/theme/api_config.dart';
import 'package:majadigi/core/theme/token_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_models.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _errorMessage = '';
  
  // User data
  int? _userId;
  String _userName = "Guest";
  String _userEmail = "";
  String _userPhone = "";
  String? _userFullName;
  UserModel? _currentUser;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String? get userFullName => _userFullName;
  int? get userId => _userId;
  UserModel? get currentUser => _currentUser;

  final ApiService _apiService = ApiService();

  Future<void> _applyAuthSession({required UserModel user, required String token}) async {
    await TokenService.saveToken(token);
    await TokenService.saveUserData(
      id: user.id,
      email: user.email,
      username: user.username,
      phone: user.phone,
      fullName: user.fullName,
    );

    _userId = user.id;
    _userEmail = user.email;
    _userName = user.username;
    _userPhone = user.phone ?? '';
    _userFullName = user.fullName;
    _currentUser = user;
    _isLoggedIn = true;
  }

  /// Initialize auth state on app startup
  Future<void> initializeAuth() async {
    final hasToken = await TokenService.hasToken();
    if (hasToken) {
      // Fetch current user profile
      try {
        final userData = await TokenService.getUserData();
        if (userData != null) {
          _userId = userData['id'];
          _userName = userData['username'] ?? 'User';
          _userEmail = userData['email'];
          _userPhone = userData['phone'] ?? '';
          _userFullName = userData['fullName'];
          _isLoggedIn = true;
        }
      } catch (e) {
        print('Error loading user data: $e');
        await logout();
      }
      notifyListeners();
    }
  }

  /// Fetch latest profile from backend (/users/me)
  Future<bool> fetchMe() async {
    if (!_isLoggedIn) return false;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.get(ApiConfig.usersMe, authenticated: true);
      final data = response is Map<String, dynamic> ? response['data'] : null;
      if (data is! Map<String, dynamic>) {
        throw ApiException('Invalid profile response', 0);
      }

      final user = UserModel.fromJson(data);
      _currentUser = user;
      _userId = user.id;
      _userEmail = user.email;
      _userName = user.username;
      _userPhone = user.phone ?? '';
      _userFullName = user.fullName;
      await TokenService.saveUserData(
        id: user.id,
        email: user.email,
        username: user.username,
        phone: user.phone,
        fullName: user.fullName,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Fetch profile failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update profile (/users/profile)
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? fullName,
    String? phone,
    String? region,
    String? address,
    String? gender,
    String? birthDate, // YYYY-MM-DD
    String? nik,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.put(
        ApiConfig.usersProfile,
        authenticated: true,
        body: {
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (fullName != null) 'fullName': fullName,
          if (phone != null) 'phone': phone,
          if (region != null) 'region': region,
          if (address != null) 'address': address,
          if (gender != null) 'gender': gender,
          if (birthDate != null) 'birthDate': birthDate,
          if (nik != null) 'nik': nik,
        },
      );

      final data = response is Map<String, dynamic> ? response['data'] : null;
      if (data is! Map<String, dynamic>) {
        throw ApiException('Invalid update response', 0);
      }

      final user = UserModel.fromJson(data);
      _currentUser = user;
      _userId = user.id;
      _userEmail = user.email;
      _userName = user.username;
      _userPhone = user.phone ?? '';
      _userFullName = user.fullName;
      await TokenService.saveUserData(
        id: user.id,
        email: user.email,
        username: user.username,
        phone: user.phone,
        fullName: user.fullName,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Update profile failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({required String oldPassword, required String newPassword}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _apiService.put(
        ApiConfig.authChangePassword,
        authenticated: true,
        body: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Change password failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login with email and password
  Future<bool> loginWithEmail({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiService.post(
        ApiConfig.authLogin,
        body: request.toJson(),
        authenticated: false,
      );

      final loginResponse = LoginResponse.fromJson(response);

      if (loginResponse.success && loginResponse.token != null && loginResponse.user != null) {
        await _applyAuthSession(user: loginResponse.user!, token: loginResponse.token!);
        _isLoading = false;
        notifyListeners();

        return true;
      } else {
        _errorMessage = loginResponse.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register new user
  Future<bool> registerUser({
    required String email,
    required String username,
    required String password,
    String? firstName,
    String? lastName,
    String? phone,
    String? nik,
    String? region,
    String? fullName,
    String? address,
    String? gender,
    String? birthDate,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final request = RegisterRequest(
        email: email,
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        nik: nik,
        region: region,
        fullName: fullName,
        address: address,
        gender: gender,
        birthDate: birthDate,
      );

      final response = await _apiService.post(
        ApiConfig.authRegister,
        body: request.toJson(),
        authenticated: false,
      );

      final registerResponse = RegisterResponse.fromJson(response);

      if (registerResponse.success && registerResponse.token != null && registerResponse.user != null) {
        await _applyAuthSession(user: registerResponse.user!, token: registerResponse.token!);
        _isLoading = false;
        notifyListeners();

        return true;
      } else {
        _errorMessage = registerResponse.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Social login (Google/Facebook) via backend verification.
  Future<bool> socialLogin({
    required String provider,
    String? idToken,
    String? accessToken,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.post(
        ApiConfig.authSocialLogin,
        body: {
          'provider': provider,
          if (idToken != null) 'idToken': idToken,
          if (accessToken != null) 'accessToken': accessToken,
        },
        authenticated: false,
      );

      final loginResponse = LoginResponse.fromJson(response);
      if (loginResponse.success && loginResponse.token != null && loginResponse.user != null) {
        await _applyAuthSession(user: loginResponse.user!, token: loginResponse.token!);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = loginResponse.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Social login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(scopes: const ['email', 'profile']);
      final account = await googleSignIn.signIn();
      if (account == null) {
        _errorMessage = 'Google sign-in dibatalkan';
        notifyListeners();
        return false;
      }

      final auth = await account.authentication;
      if (auth.idToken == null && auth.accessToken == null) {
        _errorMessage = 'Google token tidak tersedia';
        notifyListeners();
        return false;
      }

      return socialLogin(provider: 'google', idToken: auth.idToken, accessToken: auth.accessToken);
    } catch (e) {
      _errorMessage = 'Google sign-in gagal: $e';
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call logout endpoint if token exists
      final hasToken = await TokenService.hasToken();
      if (hasToken) {
        await _apiService.post(
          ApiConfig.authLogout,
          authenticated: true,
        );
      }
    } catch (e) {
      print('Logout API error: $e');
    }

    // Clear local data
    await TokenService.clearToken();
    _isLoggedIn = false;
    _userId = null;
    _userName = "Guest";
    _userEmail = "";
    _userPhone = "";
    _userFullName = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
