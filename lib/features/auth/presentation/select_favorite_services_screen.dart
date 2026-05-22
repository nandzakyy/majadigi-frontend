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

  @override
  void initState() {
    super.initState();
    final loader = Provider.of<DynamicLoaderProvider>(context, listen: false);
    _selectedTitles = loader.savedServiceTitles.toSet();
  }

  void _toggleSelection(ServiceModel service) {
    setState(() {
      if (_selectedTitles.contains(service.title)) {
        _selectedTitles.remove(service.title);
      } else if (_selectedTitles.length < 5) {
        _selectedTitles.add(service.title);
      }
    });
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
    Provider.of<DynamicLoaderProvider>(context, listen: false).saveUserPreferences(userId, 'All', _selectedTitles.toList());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Layanan favorit berhasil disimpan.')),
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
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                final isSelected = _selectedTitles.contains(service.title);
                return GestureDetector(
                  onTap: () => _toggleSelection(service),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 54,
                                width: 54,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
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
