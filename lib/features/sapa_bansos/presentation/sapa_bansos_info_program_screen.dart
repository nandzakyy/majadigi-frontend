import 'package:flutter/material.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_program_detail_screen.dart';

class SapaBansosInfoProgramScreen extends StatelessWidget {
  const SapaBansosInfoProgramScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Program',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 16),
                  _buildProgramCard(
                    context: context,
                    title: 'Program Keluarga Harapan Plus',
                    subtitle: 'Bantuan sosial bersyarat untuk kesejahteraan lansia dari keluarga penerima manfaat PKH Reguler.',
                    badge: 'PKH Plus',
                    assetPath: 'assets/images/logo_pkhp.png',
                  ),
                  _buildProgramCard(
                    context: context,
                    title: 'Kemiskinan Ekstrem',
                    subtitle: 'Bantuan tunai langsung untuk modal usaha dan meringankan beban hidup masyarakat miskin ekstrem.',
                    badge: 'Kemiskinan Ekstrem',
                    assetPath: 'assets/images/logo_kemiskinan_ekstreme.png',
                  ),
                  _buildProgramCard(
                    context: context,
                    title: 'Bantuan Langsung Tunai Dana Bagi Hasil Cukai Hasil Tembakau',
                    subtitle: 'Bantuan tunai bagi buruh pabrik rokok dan petani tembakau di luar domisili KTP.',
                    badge: 'BLT',
                    assetPath: 'assets/images/bantuan_langsung_tunai_dbh_cht.png',
                  ),
                  _buildProgramCard(
                    context: context,
                    title: 'Asistensi Sosial Penyandang Disabilitas',
                    subtitle: 'Bantuan sosial untuk memenuhi kebutuhan dasar dan meningkatkan kualitas hidup penyandang disabilitas.',
                    badge: 'Disabilitas',
                    assetPath: 'assets/images/asistensi_sosial_penyandang_disabilitas.png',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0065FF),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Informasi Program', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramCard({required BuildContext context, required String title, required String subtitle, required String badge, required String assetPath}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SapaBansosProgramDetailScreen(
              title: title,
              description: subtitle,
              assetPath: assetPath,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F2FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.info, color: Color(0xFF0065FF));
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 8),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.4)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(badge, style: const TextStyle(fontSize: 10, color: Color(0xFF0065FF), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
