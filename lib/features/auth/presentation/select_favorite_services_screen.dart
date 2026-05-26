import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:majadigi/core/theme/app_colors.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';
import 'package:majadigi/features/home/presentation/dynamic_loader_provider.dart';
import 'package:majadigi/features/home/model/service_model.dart';

class SelectFavoriteServicesScreen extends StatefulWidget {
  const SelectFavoriteServicesScreen({Key? key}) : super(key: key);

  @override
  State<SelectFavoriteServicesScreen> createState() => _SelectFavoriteServicesScreenState();
}

class _SelectFavoriteServicesScreenState extends State<SelectFavoriteServicesScreen> {
  late Set<String> _selectedTitles;
  String _selectedRegion = '';
  String _searchQuery = '';

  final List<String> _regions = [
    'Surabaya',
    'Malang',
    'Batu',
    'Kediri',
    'Trenggalek',
    'Sidoarjo',
    'Gresik',
  ];

  @override
  void initState() {
    super.initState();
    final loader = Provider.of<DynamicLoaderProvider>(context, listen: false);
    _selectedTitles = loader.savedServiceTitles.toSet();
  }

  // ================= STATE MANAGEMENT LOGIC =================

  // 1. Manual Selection & Toggle Logic
  void _toggleSelection(ServiceModel service) {
    setState(() {
      if (_selectedTitles.contains(service.title)) {
        _selectedTitles.remove(service.title);
      } else {
        if (_selectedTitles.length >= 5) {
          _showMaxLimitWarning();
        } else {
          _selectedTitles.add(service.title);
        }
      }
    });
  }

  // 2. Validation Warning
  void _showMaxLimitWarning() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Maksimal 5 layanan favorit yang dapat dipilih.'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // 3. Recommendation Selection Logic
  void _applyRecommendation(String region) {
    if (region.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih wilayah terlebih dahulu.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    // Recommended list of services per region (max 5)
    List<String> recommended;
    switch (region) {
      case 'Batu':
        recommended = ['RSUD Karsa Husada', 'Transjatim', 'Sapa Bansos', 'Sidita', 'Nomor Darurat'];
        break;
      case 'Surabaya':
        recommended = ['RSUD Dr. Soetomo', 'Islamic Center', 'Sidita', 'Transjatim', 'Nomor Darurat'];
        break;
      case 'Malang':
        recommended = ['RSUD Saiful Anwar', 'Sidita', 'Islamic Center', 'Transjatim', 'Nomor Darurat'];
        break;
      case 'Kediri':
        recommended = ['RSUD Daha Husada', 'Transjatim', 'Sapa Bansos', 'Sidita', 'Nomor Darurat'];
        break;
      default:
        recommended = ['Transjatim', 'Sapa Bansos', 'Nomor Darurat', 'Sidita', 'Islamic Center'];
        break;
    }

    final loader = Provider.of<DynamicLoaderProvider>(context, listen: false);
    final availableTitles = loader.allServices.map((s) => s.title).toSet();
    final validRecommendations = recommended.where((title) => availableTitles.contains(title)).toList();

    setState(() {
      _selectedRegion = region;
      _selectedTitles = validRecommendations.toSet();
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rekomendasi wilayah $region berhasil diterapkan.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  // 4. Reset Recommendation
  void _resetRecommendation() {
    setState(() {
      _selectedRegion = '';
      _selectedTitles.clear();
    });
  }

  // ================= UI WIDGET BUILDERS =================

  // Custom region selection sheet (searchable dropdown bottom sheet)
  void _showRegionSearchBottomSheet(BuildContext context) {
    _searchQuery = ''; // Reset query on open
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            final filtered = _regions
                .where((r) => r.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();

            return Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih Wilayah Asal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Cari wilayah...',
                      prefixIcon: const Icon(Icons.search, color: Colors.black45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (val) {
                      setModalState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: filtered.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Text(
                                'Wilayah tidak ditemukan',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: filtered.length,
                            itemBuilder: (context, idx) {
                              final reg = filtered[idx];
                              final isSelected = reg == _selectedRegion;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedRegion = reg;
                                  });
                                  Navigator.pop(context);
                                  Future.microtask(() => _applyRecommendation(reg));
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.08)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        reg,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: isSelected ? AppColors.primary : Colors.black87,
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check,
                                          color: AppColors.primary,
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecommendationSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih darimana asal daerahmu?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _showRegionSearchBottomSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedRegion.isEmpty ? '- Pilih -' : _selectedRegion,
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedRegion.isEmpty ? Colors.black38 : Colors.black87,
                      fontWeight: _selectedRegion.isEmpty ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                  _selectedRegion.isEmpty
                      ? const Icon(Icons.keyboard_arrow_down, color: Colors.black54)
                      : GestureDetector(
                          onTap: () {
                            _resetRecommendation();
                          },
                          child: const Icon(Icons.clear, color: Colors.black54, size: 20),
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dapatkan rekomendasi layanan sesuai wilayah Anda',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _applyRecommendation(_selectedRegion),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Lihat Rekomendasi',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _saveSelection() {
    if (_selectedTitles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal satu layanan terlebih dahulu.')),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.isLoggedIn ? (auth.userEmail.isNotEmpty ? auth.userEmail : auth.userName) : 'guest';
    Provider.of<DynamicLoaderProvider>(context, listen: false).saveUserPreferences(
      userId,
      _selectedRegion.isEmpty ? 'All' : _selectedRegion,
      _selectedTitles.toList(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Layanan favorit berhasil disimpan.')),
    );
    Navigator.pop(context);
  }

  void _clearFavorites() {
    Provider.of<DynamicLoaderProvider>(context, listen: false).clearPreferences();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Layanan favorit dihapus.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loader = Provider.of<DynamicLoaderProvider>(context);
    final services = loader.allServices;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: loader.hasSavedPreferences ? _clearFavorites : null,
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih 5 Layanan Favorit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pilih sampai 5 layanan untuk ditampilkan sebagai favorit di beranda.',
                  style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 12),
                Text(
                  '${_selectedTitles.length} dari 5 layanan dipilih',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecommendationSection(context),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      final isSelected = _selectedTitles.contains(service.title);
                      return GestureDetector(
                        onTap: () => _toggleSelection(service),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.18),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      height: 54,
                                      width: 54,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary.withOpacity(0.15)
                                            : AppColors.primary.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: service.assetPath != null
                                            ? (service.assetPath!.toLowerCase().endsWith('.svg')
                                                ? SvgPicture.asset(service.assetPath!, width: 32, height: 32)
                                                : Image.asset(service.assetPath!, width: 32, height: 32))
                                            : Icon(service.icon, size: 32, color: AppColors.primary),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      service.title,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      service.category,
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(Icons.check, size: 16, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: ElevatedButton(
              onPressed: _selectedTitles.isEmpty ? null : _saveSelection,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Simpan Pilihan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
