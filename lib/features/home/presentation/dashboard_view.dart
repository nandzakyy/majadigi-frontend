import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'package:majadigi/core/theme/app_colors.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';
import 'package:majadigi/features/auth/presentation/login_screen.dart';
import 'package:majadigi/features/auth/presentation/select_favorite_services_screen.dart';
import 'package:majadigi/core/widgets/custom_wave_header.dart';

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
        MaterialPageRoute(
          builder: (context) => const IslamicCenterDetailScreen(),
        ),
      );
    } else if (title.contains('rsud') ||
        title.contains('soetomo') ||
        title.contains('saiful anwar') ||
        title.contains('daha husada') ||
        title.contains('karsa husada') ||
        title.contains('haji')) {
      String normalizeHospitalName(String input) {
        return input
            .toLowerCase()
            .replaceAll('.', '')
            .replaceAll(RegExp(r'\\bdr\\b'), '')
            .replaceAll(RegExp(r'\\brsud\\b'), '')
            .replaceAll(RegExp(r'[^a-z0-9]+'), '')
            .trim();
      }

      final rsMatch = RumahSakitData.rsList.firstWhere(
        (rs) {
          final rsNameNormalized = normalizeHospitalName(rs["nama"]!);
          final serviceTitleNormalized = normalizeHospitalName(service.title);
          return rsNameNormalized.contains(serviceTitleNormalized) ||
              serviceTitleNormalized.contains(rsNameNormalized);
        },
        orElse: () => {
          "id": null,
          "nama": service.title,
          "alamat": "Jawa Timur",
          "logoPath": service.assetPath ?? "assets/images/logo_jawa_timur.png",
        },
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: '/rs-detail'),
          builder: (context) => RSDetailScreen(
            hospitalId: rsMatch["id"] as int?,
            nama: rsMatch["nama"]!,
            alamat: rsMatch["alamat"]!,
            logoPath: rsMatch["logoPath"]!,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailScreen(service: service),
        ),
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Column(
      children: [
        CustomWaveHeader(
          useWaveStyle: false,
          title: auth.isLoggedIn ? auth.userName : 'Pengunjung',
          subtitle: 'Selamat pagi',
          showBackButton: false,
          centerTitle: false,
          leadingWidget: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            child: Icon(Icons.person, color: Colors.grey.shade500, size: 28),
          ),
          rightWidget: !auth.isLoggedIn
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.login_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    await auth.logout();
                    dynamicLoader.enterGuestMode();
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
        ),
        // Content inside SafeArea so it doesn't collide with system UI
        Expanded(
          child: SafeArea(
            top: false,
            bottom: false,
            child: ListView(
              padding: EdgeInsets.only(
                top: 18,
                bottom: 110 + MediaQuery.of(context).padding.bottom,
              ),
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
                        _buildFavoritesSection(
                          context,
                          dynamicLoader,
                          auth.isLoggedIn,
                        ),
                        const SizedBox(height: 28),
                      ],

                      // When user has saved favorites, show them as white cards
                      if (hasFavorites) ...[
                        const Text(
                          'Layanan Favorit Anda',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const SelectFavoriteServicesScreen(),
                                ),
                              );
                            },
                            child: const Text('Edit Favorit'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 1.15,
                              ),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade100,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () =>
                                        _navigateToService(context, service),
                                    child: Stack(
                                      children: [
                                        // Rank Badge
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withOpacity(0.08),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '#${index + 1}',
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Centered content
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 16.0,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 12),
                                                service.assetPath != null
                                                    ? (service.assetPath!
                                                              .toLowerCase()
                                                              .endsWith('.svg')
                                                          ? SvgPicture.asset(
                                                              service
                                                                  .assetPath!,
                                                              width: 44,
                                                              height: 44,
                                                            )
                                                          : Image.asset(
                                                              service
                                                                  .assetPath!,
                                                              width: 44,
                                                              height: 44,
                                                            ))
                                                    : Icon(
                                                        service.icon,
                                                        size: 44,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  service.title,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textMain,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          _buildEkoCard(
                            context,
                            title: 'Satu Peta',
                            description:
                                'Menyediakan visualisasi spasial proyek, layanan, dan wilayah di Jawa Timur dalam satu peta terintegrasi.',
                            assetPath: 'assets/vectors/logo_satu_peta.svg',
                            url: 'https://satupeta.jatimprov.go.id/',
                          ),
                          const SizedBox(height: 12),
                          _buildEkoCard(
                            context,
                            title: 'Satu Data',
                            description:
                                'Akses data terstandar dari berbagai instansi pemerintah Jawa Timur, mendukung transparansi dan perencanaan berbasis data.',
                            assetPath: 'assets/images/logo_satu_data.png',
                            url: 'https://satudata.jatimprov.go.id/login',
                          ),
                          const SizedBox(height: 12),
                          _buildEkoCard(
                            context,
                            title: 'Open Data',
                            description:
                                'Unduh dan gunakan dataset publik dari berbagai sektor, terbuka untuk masyarakat, peneliti, dan pengembang.',
                            assetPath: 'assets/images/logo_open_data.png',
                            url: 'https://opendata.jatimprov.go.id/',
                          ),
                          const SizedBox(height: 12),
                          _buildEkoCard(
                            context,
                            title: 'Dashboard Publik',
                            description:
                                'Menampilkan visualisasi data kinerja, anggaran, dan indikator pembangunan utama Provinsi Jawa Timur secara transparan.',
                            assetPath: 'assets/images/logo_dashboard_publik.png',
                            url: 'https://dashboard.jatimprov.go.id/',
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

  Widget _buildFavoritesSection(
    BuildContext context,
    DynamicLoaderProvider loader,
    bool isLoggedIn,
  ) {
    final hasFavorites = loader.hasSavedPreferences;
    final selectedServices = loader.savedServiceTitles
        .map(
          (title) => loader.allServices.firstWhere(
            (service) => service.title == title,
            orElse: () => ServiceModel(
              title: title,
              icon: Icons.star,
              category: '',
              availableRegions: ['All'],
            ),
          ),
        )
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
        border: Border.all(
          color: const Color(0xFF0065FF).withOpacity(0.08),
          width: 1.5,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF9FAFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0065FF).withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
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
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            'Favorit',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
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
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        'Favorit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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

  Widget _buildFavoritePlaceholder(
    BuildContext context, {
    required bool isLoggedIn,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                if (isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectFavoriteServicesScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
              child: CustomPaint(
                painter: DashedBorderPainter(
                  color: AppColors.primary.withOpacity(0.35),
                  borderRadius: 14,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.07),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteServiceCard(BuildContext context, ServiceModel service) {
    final loader = Provider.of<DynamicLoaderProvider>(context, listen: false);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _navigateToService(context, service),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: service.assetPath != null
                          ? (service.assetPath!.toLowerCase().endsWith('.svg')
                                ? SvgPicture.asset(
                                    service.assetPath!,
                                    width: 24,
                                    height: 24,
                                  )
                                : Image.asset(
                                    service.assetPath!,
                                    width: 24,
                                    height: 24,
                                  ))
                          : Icon(service.icon, color: Colors.white, size: 24),
                    ),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Material(
                        color: Colors.white.withOpacity(0.2),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            loader.removeFavoriteTitle(service.title);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Dihapus dari favorit: ${service.title}',
                                ),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

  Widget _buildEkoCard(
    BuildContext context, {
    required String title,
    required String description,
    required String assetPath,
    required String url,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final uri = Uri.parse(url);
              try {
                final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tidak dapat membuka link')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tidak dapat membuka link')),
                  );
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFF6F9FF),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: assetPath.toLowerCase().endsWith('.svg')
                          ? SvgPicture.asset(assetPath)
                          : Image.asset(assetPath),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.gap = 4.0,
    this.dash = 6.0,
    this.borderRadius = 14.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? dash : gap;
        dashedPath.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += len;
        draw = !draw;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dash != dash ||
        oldDelegate.borderRadius != borderRadius;
  }
}
