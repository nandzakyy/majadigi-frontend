import 'package:flutter/material.dart';
import 'package:majadigi/core/widgets/custom_wave_header.dart';

class AboutMajadigiScreen extends StatelessWidget {
  const AboutMajadigiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomWaveHeader(title: 'Tentang Majadigi'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/majadigi_logo.png',
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Sekilas Majadigi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Majadigi adalah platform layanan publik digital berbasis web dan mobile diluncurkan pada Oktober 2024. Majadigi menyajikan informasi penting dan akses ke layanan publik yang terintegrasi dengan pemerintah kabupaten / kota di Jawa Timur.\n\n'
                    'Di Majadigi, kami mengembangkan integrasi layanan publik dengan sistem Single Sign On (SSO). Pengguna bisa akses layanan publik lebih praktis cukup dari satu aplikasi. Dapatkan juga update seputar:\n'
                    '1. Lowongan kerja & pelatihan\n'
                    '2. Fasilitas kesehatan\n'
                    '3. Harga sembako\n'
                    '4. Destinasi wisata\n'
                    '5. Event budaya, dan lainnya.\n\n'
                    'Kedepannya, Pemprov Jatim berencana mengintegrasikan Majadigi dengan portal layanan nasional dikembangkan oleh GovTech Indonesia (INA Digital). Majapahit Digital (Majadigi), layanan publik kini jadi lebih mudah dan praktis dalam satu aplikasi.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
