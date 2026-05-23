import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:majadigi/core/theme/app_colors.dart';
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
    final loader = Provider.of<DynamicLoaderProvider>(context);
    final services = loader.allServices.where((s) => s.title.toLowerCase().contains(_query.toLowerCase())).toList();

    // ensure status bar color matches header so the top area is fully blue
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: AppColors.primary, statusBarIconBrightness: Brightness.light));
    return Scaffold(
      body: Column(
        children: [
          // Full-bleed header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Text('Semua Layanan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        decoration: const InputDecoration(hintText: 'Cari Layanan', prefixIcon: Icon(Icons.search), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final s = services[index];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            onTap: () => _navigateToService(context, s),
                            leading: s.assetPath != null
                                ? (s.assetPath!.toLowerCase().endsWith('.svg') ? SvgPicture.asset(s.assetPath!, width: 40, height: 40) : Image.asset(s.assetPath!, width: 40, height: 40))
                                : Icon(s.icon, color: AppColors.primary),
                            title: Text(s.title),
                            subtitle: Text(s.category),
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
