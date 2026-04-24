import 'package:flutter/material.dart';
import '../../core/models/service_model.dart';
import '../../core/models/user_preference_model.dart';

class DynamicLoaderProvider extends ChangeNotifier {
  // Mock Database Layer: List of all available services
  final List<ServiceModel> _allServices = [
    ServiceModel(title: 'Sapa Bansos', icon: Icons.volunteer_activism, category: 'Bantuan Sosial', availableRegions: ['All']),
    ServiceModel(title: 'Nomor Darurat', icon: Icons.emergency, category: 'Bantuan Sosial', availableRegions: ['All']),
    ServiceModel(title: 'Transjatim', icon: Icons.directions_bus, category: 'Transportasi', availableRegions: ['Surabaya', 'Sidoarjo', 'Gresik', 'Mojokerto']),
    ServiceModel(title: 'RSUD Dr. Soetomo', icon: Icons.local_hospital, category: 'Rawat Jalan/Poliklinik', availableRegions: ['Surabaya']),
    ServiceModel(title: 'RSUD Saiful Anwar', icon: Icons.health_and_safety, category: 'Rawat Jalan/Poliklinik', availableRegions: ['Malang']),
    ServiceModel(title: 'Destinasi Wisata', icon: Icons.map, category: 'Informasi Daerah', availableRegions: ['All']),
    ServiceModel(title: 'Khas Jatim', icon: Icons.shopping_bag, category: 'Informasi Daerah', availableRegions: ['All']),
    ServiceModel(title: 'RSUD Karsa Husada', icon: Icons.medical_services, category: 'Rawat Inap', availableRegions: ['Batu', 'Malang']),
    ServiceModel(title: 'Sidita', icon: Icons.map_outlined, category: 'Informasi Daerah', availableRegions: ['All']),
    ServiceModel(title: 'RSUD Haji', icon: Icons.healing, category: 'IGD', availableRegions: ['Surabaya']),
    ServiceModel(title: 'RSUD Daha Husada', icon: Icons.monitor_heart, category: 'Laboratorium & Radiologi', availableRegions: ['Kediri']),
    ServiceModel(title: 'e-TIBI', icon: Icons.personal_injury, category: 'Penunjang Medik', availableRegions: ['All']),
  ];

  UserPreferenceModel? _userPreference;
  List<ServiceModel> _personalizedServices = [];

  List<ServiceModel> get personalizedServices => _personalizedServices.isNotEmpty 
      ? _personalizedServices 
      : _allServices.take(8).toList();

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
    if (_userPreference == null) {
      _personalizedServices = _allServices.take(10).toList();
      notifyListeners();
      return;
    }

    String region = _userPreference!.region;
    List<String> prefCategories = _userPreference!.preferredServices;

    // 2. Filter by Request (Region)
    var regionFiltered = _allServices.where((s) {
      return s.availableRegions.contains('All') || s.availableRegions.contains(region);
    }).toList();

    // 3. Filter by User Preferences
    var preferenceFiltered = regionFiltered;
    if (prefCategories.isNotEmpty) {
      preferenceFiltered = regionFiltered.where((s) {
         return prefCategories.contains(s.title) || prefCategories.contains(s.category);
      }).toList();
      
      // Ranking & Sorting Logic (fill empty slots so dashboard doesn't look empty)
      if (preferenceFiltered.length < 8) {
         final others = regionFiltered.where((s) => !preferenceFiltered.contains(s)).take(8 - preferenceFiltered.length);
         preferenceFiltered.addAll(others);
      }
    }

    _personalizedServices = preferenceFiltered;
    notifyListeners();
  }
}
