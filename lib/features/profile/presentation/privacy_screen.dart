import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kebijakan Privasi', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D6EFD),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/majadigi_logo.png',
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Kebijakan Privasi Aplikasi Majadigi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Pendahuluan\n'
              'Majadigi adalah aplikasi portal layanan resmi Provinsi Jawa Timur yang berkomitmen untuk melindungi privasi pengguna. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, mengungkapkan, dan melindungi informasi pribadi Anda saat menggunakan aplikasi Majadigi.\n\n'
              '2. Informasi yang Dikumpulkan\n'
              'Kami dapat mengumpulkan informasi berikut:\n'
              'a. Informasi Identitas: Nama, alamat email, nomor telepon, dan data lain yang diperlukan untuk pendaftaran.\n'
              'b. Informasi Perangkat: Jenis perangkat, sistem operasi, dan alamat IP.\n'
              'c. Data Penggunaan: Aktivitas pengguna di dalam aplikasi, termasuk layanan yang diakses.\n'
              'd. Data Lokasi: Jika diizinkan oleh pengguna, untuk menyediakan layanan berbasis lokasi.\n\n'
              '3. Penggunaan Informasi\n'
              'Informasi yang dikumpulkan digunakan untuk:\n'
              'a. Menyediakan dan meningkatkan layanan dalam aplikasi.\n'
              'b. Memproses permohonan dan transaksi pengguna.\n'
              'c. Mengirimkan notifikasi, pembaruan, dan informasi layanan.\n'
              'd. Memastikan keamanan dan kepatuhan terhadap hukum.\n\n'
              '4. Perlindungan Data Pengguna\n'
              'Kami menerapkan langkah-langkah keamanan untuk melindungi informasi pengguna dari akses yang tidak sah, kehilangan, atau penyalahgunaan. Namun, pengguna juga bertanggung jawab untuk menjaga keamanan akun mereka.\n\n'
              '5. Berbagi Informasi dengan Pihak Ketiga\n'
              'Kami tidak menjual atau menyewakan informasi pribadi pengguna kepada pihak ketiga. Namun, kami dapat membagikan informasi dengan:\n'
              'a. Instansi pemerintah terkait untuk kepentingan layanan publik.\n'
              'b. Penyedia layanan pihak ketiga yang membantu dalam operasional aplikasi.\n'
              'c. Pihak yang berwenang jika diwajibkan oleh hukum.\n\n'
              '6. Hak Pengguna\n'
              'Pengguna memiliki hak untuk:\n'
              'a. Mengakses dan memperbarui informasi pribadi mereka.\n'
              'b. Meminta penghapusan akun dan data pribadi mereka, sesuai dengan ketentuan yang berlaku.\n'
              'c. Mengelola preferensi terkait notifikasi dan penggunaan data.\n\n'
              '7. Perubahan Kebijakan Privasi\n'
              'Kebijakan ini dapat diperbarui dari waktu ke waktu. Kami akan memberitahukan pengguna mengenai perubahan signifikan melalui aplikasi atau media resmi lainnya.\n\n'
              '8. Hubungi Kami\n'
              'Jika ada pertanyaan terkait Kebijakan Privasi ini, pengguna dapat menghubungi layanan bantuan melalui email atau kontak resmi yang tersedia di aplikasi Majadigi.\n\n'
              'Dengan menggunakan aplikasi Majadigi, berarti setuju dengan semua syarat dan ketentuan yang tercantum dalam Kebijakan Privasi.',
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
    );
  }
}
