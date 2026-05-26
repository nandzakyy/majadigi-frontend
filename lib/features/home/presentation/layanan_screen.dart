import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:majadigi/core/theme/app_colors.dart';
import 'package:majadigi/core/widgets/custom_wave_header.dart';
import 'package:majadigi/features/home/model/service_model.dart';
import 'package:majadigi/features/nomor_darurat/presentation/nomor_darurat_main_screen.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_main_screen.dart';
import 'package:majadigi/features/services/presentation/service_detail_screen.dart';
import 'package:majadigi/features/transjatim/presentation/transjatim_main_screen.dart';
import 'package:majadigi/features/home/presentation/dynamic_loader_provider.dart';
import 'package:majadigi/features/sidita/presentation/sidita_screen.dart';
import 'package:majadigi/features/islamic_center/presentation/islamic_center_detail_screen.dart';
import 'package:majadigi/features/rumah_sakit/presentation/rs_detail_screen.dart';
import 'package:majadigi/features/rumah_sakit/data/rumah_sakit_data.dart';

class LayananScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const LayananScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<LayananScreen> createState() => _LayananScreenState();
}

class _LayananScreenState extends State<LayananScreen> {
  String _query = '';

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
          return rsNameNormalized.contains(serviceTitleNormalized) || serviceTitleNormalized.contains(rsNameNormalized);
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
        MaterialPageRoute(builder: (context) => ServiceDetailScreen(service: service)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loader = Provider.of<DynamicLoaderProvider>(context);
    final services = loader.allServices.where((s) => s.title.toLowerCase().contains(_query.toLowerCase())).toList();

    // ensure status bar color matches header so the top area is fully blue
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: Column(
        children: [
          CustomWaveHeader(
            useWaveStyle: false,
            bottomCurveColor: AppColors.background,
            title: 'Semua Layanan',
            onBackTap: widget.onBack,
          ),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.015),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Cari Layanan',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                        bottom: 110 + MediaQuery.of(context).padding.bottom,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.15,
                      ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final s = services[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade100, width: 1.5),
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
                                onTap: () => _navigateToService(context, s),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      s.assetPath != null
                                          ? (s.assetPath!.toLowerCase().endsWith('.svg')
                                              ? SvgPicture.asset(s.assetPath!, width: 44, height: 44)
                                              : Image.asset(s.assetPath!, width: 44, height: 44))
                                          : Icon(s.icon, size: 44, color: AppColors.primary),
                                      const SizedBox(height: 10),
                                      Text(
                                        s.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textMain,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
