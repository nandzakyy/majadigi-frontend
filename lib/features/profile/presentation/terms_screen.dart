import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Syarat dan Ketentuan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
              'Syarat & Ketentuan Pengguna Aplikasi Majadigi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Pendahuluan\n'
              'Selamat datang di Majadigi, aplikasi portal layanan resmi Provinsi Jawa Timur. Dengan mengakses dan menggunakan aplikasi ini, pengguna dianggap telah membaca, memahami, dan menyetujui Syarat & Ketentuan yang berlaku. Jika pengguna tidak menyetujui ketentuan ini, disarankan untuk tidak menggunakan aplikasi Majadigi.\n\n'
              '2. Ketentuan Pengguna\n'
              'a. Pengguna harus memiliki akun yang terdaftar dan memberikan informasi yang akurat serta terbaru.\n'
              'b. Pengguna bertanggung jawab atas keamanan akun, termasuk menjaga kerahasiaan kata sandi.\n'
              'c. Dilarang menggunakan aplikasi ini untuk tujuan yang melanggar hukum atau merugikan pihak lain.\n\n'
              '3. Layanan yang Disediakan\n'
              'a. Majadigi menyediakan berbagai layanan digital yang terkait dengan administrasi dan pelayanan publik di Provinsi Jawa Timur.\n'
              'b. Pemerintah Provinsi Jawa Timur berhak menambah, mengubah, atau menghentikan layanan kapan saja tanpa pemberitahuan sebelumnya.\n\n'
              '4. Penggunaan Data & Privasi\n'
              'a. Majadigi mengelola data pengguna sesuai dengan Kebijakan Privasi yang berlaku.\n'
              'b. Data pribadi pengguna akan digunakan hanya untuk kepentingan pelayanan publik dan tidak akan disalahgunakan.\n'
              'c. Dengan menggunakan aplikasi ini, pengguna menyetujui pengumpulan dan pemrosesan data sesuai dengan kebijakan yang berlaku.\n\n'
              '5. Hak Kekayaan Intelektual\n'
              'a. Semua hak cipta, merek dagang, dan hak kekayaan intelektual lainnya dalam aplikasi ini dimiliki oleh Pemerintah Provinsi Jawa Timur.\n'
              'b. Pengguna dilarang memperbanyak, mendistribusikan, atau menggunakan materi dalam aplikasi tanpa izin resmi.\n\n'
              '6. Pembatasan Tanggung Jawab\n'
              'a. Majadigi berupaya memberikan informasi dan layanan yang akurat, tetapi tidak menjamin bahwa semua informasi akan selalu bebas dari kesalahan atau gangguan teknis.\n'
              'b. Pengguna setuju bahwa penggunaan aplikasi ini sepenuhnya merupakan tanggung jawab pribadi.\n\n'
              '7. Perubahan Syarat & Ketentuan\n'
              'Pemerintah Provinsi Jawa Timur dapat mengubah Syarat & Ketentuan ini sewaktu-waktu. Pengguna disarankan untuk selalu memeriksa pembaruan yang tersedia dalam aplikasi.\n\n'
              '8. Hubungi Kami\n'
              'Jika terdapat pertanyaan atau kendala terkait penggunaan aplikasi Majadigi, silakan menghubungi layanan bantuan melalui email atau kanal komunikasi resmi yang tersedia di aplikasi.\n\n'
              '9. Persetujuan\n'
              'Dengan menggunakan aplikasi Majadigi, pengguna menyatakan telah memahami dan menyetujui seluruh ketentuan yang berlaku.',
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
