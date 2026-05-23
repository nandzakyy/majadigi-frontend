import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:majadigi/core/theme/app_colors.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';
import 'package:majadigi/features/auth/presentation/login_screen.dart';
import 'package:majadigi/features/auth/presentation/select_favorite_services_screen.dart';

import 'package:majadigi/features/home/presentation/dynamic_loader_provider.dart';
import 'package:majadigi/features/home/model/service_model.dart';
import 'package:majadigi/features/transjatim/presentation/transjatim_main_screen.dart';
import 'package:majadigi/features/nomor_darurat/presentation/nomor_darurat_main_screen.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_main_screen.dart';
import 'package:majadigi/features/services/presentation/service_detail_screen.dart';
import 'package:majadigi/features/sidita/presentation/sidita_screen.dart';
import 'package:majadigi/features/islamic_center/presentation/islamic_center_detail_screen.dart';
import 'package:majadigi/features/rumah_sakit/presentation/rs_detail_screen.dart';
import 'package:majadigi/features/rumah_sakit/data/rumah_sakit_data.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  void _navigateToService(BuildContext context, ServiceModel service) {
    final String title = service.title.toLowerCase();
    if (title.contains('sapa bansos')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SapaBansosMainScreen()),
      );
    } else if (title.contains('nomor darurat')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NomorDaruratMainScreen()),
      );
    } else if (title.contains('transjatim')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TransJatimMainScreen()),
      );
    } else if (title.contains('sidita')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SiditaScreen()),
      );
    } else if (title.contains('islamic center')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const IslamicCenterDetailScreen()),
      );
    } else if (title.contains('rsud') ||
        title.contains('soetomo') ||
        title.contains('saiful anwar') ||
        title.contains('daha husada') ||
        title.contains('karsa husada') ||
        title.contains('haji')) {
      final rsMatch = RumahSakitData.rsList.firstWhere(
        (rs) {
          final rsNameNormalized = rs["nama"]!.replaceAll('.', '').toLowerCase();
          final serviceTitleNormalized = service.title.replaceAll('.', '').toLowerCase();
          return rsNameNormalized.contains(serviceTitleNormalized) || serviceTitleNormalized.contains(rsNameNormalized);
        },
        orElse: () => {
          "nama": service.title,
          "alamat": "Jawa Timur",
          "logoPath": service.assetPath ?? "assets/images/logo_jawa_timur.png",
        },
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RSDetailScreen(
            nama: rsMatch["nama"]!,
            alamat: rsMatch["alamat"]!,
            logoPath: rsMatch["logoPath"]!,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServiceDetailScreen(service: service)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    final dynamicLoader = Provider.of<DynamicLoaderProvider>(context);
    final List<ServiceModel> services = dynamicLoader.personalizedServices;
    final bool hasFavorites = dynamicLoader.hasSavedPreferences;
    // ensure status bar color matches header so the top area is fully blue
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: AppColors.primary, statusBarIconBrightness: Brightness.light));
    return Column(
      children: [
        // Full-bleed header (no SafeArea) so blue extends to status bar edges
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${auth.isLoggedIn ? auth.userName : "Guest"}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      auth.isLoggedIn ? 'Selamat datang di Superapp Majadigi' : 'Silakan login untuk fitur penuh',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              if (!auth.isLoggedIn)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    side: const BorderSide(color: Colors.white70),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Login'),
                ),
              if (auth.isLoggedIn)
                IconButton(
                  onPressed: () {
                    auth.logout();
                    dynamicLoader.clearPreferences();
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                )
            ],
          ),
        ),
        // Content inside SafeArea so it doesn't collide with system UI
        Expanded(
          child: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 18),
              children: [
                // The rest of the page content is horizontally padded so header can be full-bleed
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!hasFavorites) ...[
                        Text(
                          'Favorit',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildFavoritesSection(context, dynamicLoader, auth.isLoggedIn),
                        const SizedBox(height: 28),
                      ],

                      // When user has saved favorites, show them as white cards
                      if (hasFavorites) ...[
                        const Text(
                          'Layanan Favorit Anda',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _navigateToService(context, service),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      service.assetPath != null
                                          ? (service.assetPath!.toLowerCase().endsWith('.svg')
                                              ? SvgPicture.asset(service.assetPath!, width: 48, height: 48)
                                              : Image.asset(service.assetPath!, width: 48, height: 48))
                                          : Icon(service.icon, size: 48, color: AppColors.primary),
                                      const SizedBox(height: 8),
                                      Text(
                                        service.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                      ],

                      // Ekosistem Data Jawa Timur Section
                      const SizedBox(height: 28),
                      const Text(
                        'Ekosistem Data Jawa Timur',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          _buildEkoCard(
                            context,
                            title: 'Satu Peta',
                            description: 'Menyediakan visualisasi spasial proyek, layanan, dan wilayah di Jawa Timur dalam satu peta terintegrasi.',
                            assetPath: 'assets/vectors/logo_satu_peta.svg',
                            url: 'https://satupeta.jatimprov.go.id/',
                          ),
                          const SizedBox(height: 12),
                          _buildEkoCard(
                            context,
                            title: 'Satu Data',
                            description: 'Akses data terstandar dari berbagai instansi pemerintah Jawa Timur, mendukung transparansi dan perencanaan berbasis data.',
                            assetPath: 'assets/images/logo_satu_data.png',
                            url: 'https://satudata.jatimprov.go.id/login',
                          ),
                          const SizedBox(height: 12),
                          _buildEkoCard(
                            context,
                            title: 'Open Data',
                            description: 'Unduh dan gunakan dataset publik dari berbagai sektor, terbuka untuk masyarakat, peneliti, dan pengembang.',
                            assetPath: 'assets/images/logo_open_data.png',
                            url: 'https://opendata.jatimprov.go.id/',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildFavoritesSection(BuildContext context, DynamicLoaderProvider loader, bool isLoggedIn) {
    final hasFavorites = loader.hasSavedPreferences;
    final selectedServices = loader.savedServiceTitles
        .map((title) => loader.allServices.firstWhere((service) => service.title == title, orElse: () => ServiceModel(title: title, icon: Icons.star, category: '', availableRegions: ['All'])))
        .toList();
    final List<Widget> cards = [];

    for (var i = 0; i < selectedServices.length; i++) {
      cards.add(_buildFavoriteServiceCard(context, selectedServices[i]));
    }
    for (var i = selectedServices.length; i < 5; i++) {
      cards.add(_buildFavoritePlaceholder(context, isLoggedIn: isLoggedIn));
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isLoggedIn)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            'Favorit',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        'Favorit',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        'Layanan',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Anda bisa menambahkan layanan favorit anda disini!',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: cards,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritePlaceholder(BuildContext context, {required bool isLoggedIn}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          if (isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SelectFavoriteServicesScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        },
        child: Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteServiceCard(BuildContext context, ServiceModel service) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _navigateToService(context, service),
        child: Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Center(
            child: service.assetPath != null
                ? (service.assetPath!.toLowerCase().endsWith('.svg')
                    ? SvgPicture.asset(service.assetPath!, width: 28, height: 28)
                    : Image.asset(service.assetPath!, width: 28, height: 28))
                : Icon(service.icon, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
  Widget _buildServiceIcon(ServiceModel service) {
    final assetPath = service.assetPath;

    if (assetPath != null) {
      if (assetPath.toLowerCase().endsWith('.svg')) {
        return SvgPicture.asset(assetPath, fit: BoxFit.contain);
      }
      return Image.asset(assetPath, fit: BoxFit.contain);
    }

    return Icon(service.icon, color: AppColors.primary, size: 28);
  }

  Widget _buildEkoCard(BuildContext context, {required String title, required String description, required String assetPath, required String url}) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        final can = await canLaunchUrl(uri);
        if (!can) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat membuka link')));
          return;
        }
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.cardBg),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: assetPath.toLowerCase().endsWith('.svg')
                      ? SvgPicture.asset(assetPath)
                      : Image.asset(assetPath),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(description, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
