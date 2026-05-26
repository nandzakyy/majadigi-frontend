/// API Configuration for MAJADIGI
/// Platform-aware base URL configuration
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Get base URL based on platform
  /// Android Emulator: http://10.0.2.2:3000
  /// Physical Device/Web: http://localhost:3000
  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl;
    }

    // Flutter Web cannot use `dart:io` / `Platform.*`.
    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      case TargetPlatform.iOS:
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
      default:
        return 'http://localhost:3000';
    }
  }

  static const String apiVersion = '/api';
  
  // Auth endpoints
  static const String authRegister = '$apiVersion/auth/register';
  static const String authLogin = '$apiVersion/auth/login';
  static const String authLogout = '$apiVersion/auth/logout';
  static const String authChangePassword = '$apiVersion/auth/change-password';
  static const String authSocialLogin = '$apiVersion/auth/social-login';

  // User endpoints
  static const String usersMe = '$apiVersion/users/me';
  static const String usersProfile = '$apiVersion/users/profile';
  static const String usersRegionPreferences = '$apiVersion/users/region-preferences';
  static const String usersRoles = '$apiVersion/users/roles';
  static const String usersPreferences = '$apiVersion/users/preferences';
  static const String usersLoginHistory = '$apiVersion/users/login-history';
  static const String usersOnboarding = '$apiVersion/users/onboarding';
  static const String usersFavoriteServices = '$apiVersion/users/favorite-services';

  // Category endpoints
  static const String categories = '$apiVersion/categories';

  // Hospital endpoints
  static const String hospitals = '$apiVersion/hospitals';
  static String hospitalDetail(int id) => '$apiVersion/hospitals/$id';
  static String hospitalPolyclinics(int id) => '$apiVersion/hospitals/$id/polyclinics';
  static String polyclinicDoctors(int id) => '$apiVersion/polyclinics/$id/doctors';
  static String doctorSchedules(int id) => '$apiVersion/doctors/$id/schedules';
  static String hospitalRooms(int id) => '$apiVersion/hospitals/$id/rooms';
  static String hospitalInfo(int id) => '$apiVersion/hospitals/$id/info';

  // Sapa Bansos endpoints
  static const String sapaPrograms = '$apiVersion/sapa-bansos/programs';
  static String sapaProgramDetail(int id) => '$apiVersion/sapa-bansos/programs/$id';
  static const String sapaMyApplications = '$apiVersion/sapa-bansos/my-applications';
  static String sapaApplicationDetail(int id) => '$apiVersion/sapa-bansos/applications/$id';
  static const String sapaApply = '$apiVersion/sapa-bansos/apply';

  // Islamic Center endpoints
  static const String islamicCenters = '$apiVersion/islamic-centers';
  static String islamicCenterDetail(int id) => '$apiVersion/islamic-centers/$id';
  static String islamicCenterPrayerTimes(int id) => '$apiVersion/islamic-centers/$id/prayer-times';
  static String islamicCenterEvents(int id) => '$apiVersion/islamic-centers/$id/events';

  // TransJatim endpoints
  static const String transJatimCities = '$apiVersion/transjatim/cities';
  static const String transJatimRoutes = '$apiVersion/transjatim/routes';
  static String transJatimRouteDetail(int id) => '$apiVersion/transjatim/routes/$id';
  static const String transJatimSchedulesSearch = '$apiVersion/transjatim/schedules/search';
  static String transJatimRouteSchedules(int id) => '$apiVersion/transjatim/routes/$id/schedules';
  static String transJatimTracking(int scheduleId) => '$apiVersion/transjatim/tracking/$scheduleId';

  // Emergency contacts
  static const String emergencyRegions = '$apiVersion/emergency/regions';
  static String emergencyContacts({String? region}) =>
      region == null || region.isEmpty ? '$apiVersion/emergency/contacts' : '$apiVersion/emergency/contacts?region=$region';

  // Queue endpoints
  static const String queues = '$apiVersion/queues';
  static const String myQueues = '$apiVersion/queues/my';

  // Health check
  static const String health = '/health';

  static const int connectionTimeout = 30000;
  static const int responseTimeout = 30000;
}
