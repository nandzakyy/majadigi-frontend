import 'package:flutter/material.dart';
import 'package:majadigi/features/home/model/service_model.dart';
import 'package:majadigi/features/home/model/user_preference_model.dart';

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
    // Initial fetch for guest/unauthenticated user
    _generateDashboard();
  }

  void saveUserPreferences(String userId, String region, List<String> prefs) {
    _userPreference = UserPreferenceModel(userId: userId, region: region, preferredServices: prefs);
    _generateDashboard();
  }
  
  void clearPreferences() {
    _userPreference = null;
    _generateDashboard();
  }

  

  void _generateDashboard() {
    // 1. If Guest / No Preferences -> Return default dashboard services
    if (_userPreference == null || _userPreference!.preferredServices.isEmpty) {
      _personalizedServices = _allServices.take(8).toList();
      notifyListeners();
      return;
    }

    String region = _userPreference!.region;
    List<String> selectedTitles = _userPreference!.preferredServices;

    // 2. Take services that match the selected bookmark titles (always include chosen favorites)
    final selectedServices = _allServices.where((s) => selectedTitles.contains(s.title)).toList();

    // Show only up to 5 bookmarked services; fill with defaults if needed.
    _personalizedServices = selectedServices.take(5).toList();
    if (_personalizedServices.length < 5) {
      final others = _allServices.where((s) => !_personalizedServices.contains(s) && (s.availableRegions.contains('All') || s.availableRegions.contains(region))).take(5 - _personalizedServices.length);
      _personalizedServices.addAll(others);
    }

    notifyListeners();
  }

  // no favorites convenience - reverted to original behavior
}
