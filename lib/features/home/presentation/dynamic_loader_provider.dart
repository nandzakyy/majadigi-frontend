import 'package:flutter/material.dart';
import 'package:majadigi/features/home/model/service_model.dart';
import 'package:majadigi/features/home/model/user_preference_model.dart';
import 'package:majadigi/core/theme/favorites_service.dart';
import 'package:majadigi/core/theme/api_service.dart';
import 'package:majadigi/core/theme/api_config.dart';

class DynamicLoaderProvider extends ChangeNotifier {
  // Mock Database Layer: List of all available services
  final List<ServiceModel> _allServices = [
    ServiceModel(title: 'Sapa Bansos', icon: Icons.volunteer_activism, category: 'Bantuan Sosial', availableRegions: ['All'], assetPath: 'assets/images/sapa_bansos.png'),
    ServiceModel(title: 'Nomor Darurat', icon: Icons.emergency, category: 'Bantuan Sosial', availableRegions: ['All'], assetPath: 'assets/images/logo_jawa_timur.png'),
    ServiceModel(title: 'Transjatim', icon: Icons.directions_bus, category: 'Transportasi', availableRegions: ['Surabaya', 'Sidoarjo', 'Gresik', 'Mojokerto'], assetPath: 'assets/images/logo_trans_jatim.png'),
    ServiceModel(title: 'RSUD Dr. Soetomo', icon: Icons.local_hospital, category: 'Rawat Jalan/Poliklinik', availableRegions: ['Surabaya'], assetPath: 'assets/vectors/logo_rsud_dr_soetomo.svg'),
    ServiceModel(title: 'RSUD Saiful Anwar', icon: Icons.health_and_safety, category: 'Rawat Jalan/Poliklinik', availableRegions: ['Malang'], assetPath: 'assets/images/logo_rsud_dr_saiful_anwar.png'),
    ServiceModel(title: 'RSUD Daha Husada', icon: Icons.monitor_heart, category: 'Laboratorium & Radiologi', availableRegions: ['Kediri'], assetPath: 'assets/images/logo_rsud_daha_husada.png'),
    ServiceModel(title: 'Islamic Center', icon: Icons.mosque, category: 'Informasi Daerah', availableRegions: ['All'], assetPath: 'assets/images/Islamic_Center.png'),
    ServiceModel(title: 'RSUD Karsa Husada', icon: Icons.medical_services, category: 'Rawat Inap', availableRegions: ['Batu', 'Malang'], assetPath: 'assets/images/logo_rsud_karsa_husada_batu.png'),
    ServiceModel(title: 'Sidita', icon: Icons.map_outlined, category: 'Informasi Daerah', availableRegions: ['All'], assetPath: 'assets/images/Sidita.png'),
    ServiceModel(title: 'RSUD Haji', icon: Icons.healing, category: 'IGD', availableRegions: ['Surabaya'], assetPath: 'assets/images/logo_rsud_haji_prov_jatim.png'),
  ];

  UserPreferenceModel? _userPreference;
  List<ServiceModel> _personalizedServices = [];

  List<ServiceModel> get personalizedServices => _personalizedServices.isNotEmpty 
      ? _personalizedServices 
      : _allServices.take(8).toList();

  bool get hasSavedPreferences => _userPreference != null && _userPreference!.preferredServices.isNotEmpty;

  List<String> get savedServiceTitles => _userPreference?.preferredServices ?? [];

  // Expose all services so selection screen can list them
  List<ServiceModel> get allServices => List.unmodifiable(_allServices);


  DynamicLoaderProvider() {
    enterGuestMode();
  }

  Future<void> _loadPersistedPreferencesForUser(String userKey) async {
    final persisted = await FavoritesService.loadForUser(userKey: userKey);
    if (persisted != null && persisted.titles.isNotEmpty) {
      _userPreference = UserPreferenceModel(
        userId: userKey,
        region: persisted.region.isEmpty ? 'All' : persisted.region,
        preferredServices: persisted.titles,
      );
    }
    _generateDashboard();
  }

  void enterGuestMode() {
    _userPreference = null;
    _generateDashboard();
    // Only load guest favorites if you later decide to support them.
  }

  Future<void> syncFromBackendIfLoggedIn({required String userKey}) async {
    try {
      final response = await ApiService().get(ApiConfig.usersFavoriteServices, authenticated: true);
      final data = response is Map<String, dynamic> ? response['data'] : null;
      if (data is! Map) return;
      final region = (data['region'] ?? 'All').toString();
      final favorites = data['favorites'];
      if (favorites is! List) return;
      final titles = favorites.map((e) => '$e').toList();

      if (titles.isEmpty) {
        await _loadPersistedPreferencesForUser(userKey);
        return;
      }
      _userPreference = UserPreferenceModel(userId: userKey, region: region.isEmpty ? 'All' : region, preferredServices: titles);
      await FavoritesService.saveForUser(userKey: userKey, region: region.isEmpty ? 'All' : region, titles: titles);
      _generateDashboard();
    } catch (_) {
      await _loadPersistedPreferencesForUser(userKey);
    }
  }

  void saveUserPreferences(String userId, String region, List<String> prefs) {
    _userPreference = UserPreferenceModel(userId: userId, region: region, preferredServices: prefs);
    FavoritesService.saveForUser(userKey: userId, region: region, titles: prefs);
    if (userId != 'guest') {
      ApiService()
          .put(
            ApiConfig.usersFavoriteServices,
            authenticated: true,
            body: {
              'region': region,
              'favorites': prefs,
            },
          )
          .catchError((_) {});
    }
    _generateDashboard();
  }

  void addFavoriteTitle(String title, {String region = 'All'}) {
    final current = _userPreference?.preferredServices ?? <String>[];
    if (current.contains(title)) return;
    if (current.length >= 5) return;

    final updated = [...current, title];
    final effectiveRegion = _userPreference?.region ?? region;
    _userPreference = UserPreferenceModel(userId: _userPreference?.userId ?? 'local', region: effectiveRegion, preferredServices: updated);
    FavoritesService.saveForUser(userKey: _userPreference?.userId ?? 'local', region: effectiveRegion, titles: updated);
    _generateDashboard();
  }
  
  void clearPreferences() {
    final key = _userPreference?.userId ?? 'guest';
    _userPreference = null;
    FavoritesService.clearForUser(userKey: key);
    _generateDashboard();
  }

  void removeFavoriteTitle(String title) {
    final current = _userPreference?.preferredServices ?? <String>[];
    final updated = current.where((t) => t != title).toList();
    if (updated.isEmpty) {
      clearPreferences();
      return;
    }
    final region = _userPreference?.region ?? 'All';
    _userPreference = UserPreferenceModel(userId: _userPreference?.userId ?? 'local', region: region, preferredServices: updated);
    FavoritesService.saveForUser(userKey: _userPreference?.userId ?? 'local', region: region, titles: updated);
    _generateDashboard();
  }

  

  void _generateDashboard() {
    // 1. If Guest / No Preferences -> Return default dashboard services
    if (_userPreference == null || _userPreference!.preferredServices.isEmpty) {
      _personalizedServices = _allServices.take(8).toList();
      notifyListeners();
      return;
    }

    final selectedTitles = _userPreference!.preferredServices;

    // 2. Show exactly what user selected (preserve selection order).
    _personalizedServices = selectedTitles
        .map((title) => _allServices.firstWhere(
              (s) => s.title == title,
              orElse: () => ServiceModel(title: title, icon: Icons.star, category: '', availableRegions: const ['All']),
            ))
        .toList();

    notifyListeners();
  }

  // no favorites convenience - reverted to original behavior
}
