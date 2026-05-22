import 'package:flutter/material.dart';

class AboutJatimScreen extends StatelessWidget {
  const AboutJatimScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tentang Jatim', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D6EFD),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 64, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sekilas Profil Jawa Timur',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Terletak di ujung timur Pulau Jawa, Indonesia, Provinsi Jawa Timur secara administratif terdiri dari 29 kabupaten, dan 9 kota. Melansir laman BPS Tahun 2023, luas wilayah Jawa Timur sekitar 48.036,84 km². Jawa Timur menjadi wilayah dengan jumlah penduduk terbanyak di Indonesia, populasinya lebih dari 40 juta jiwa. Jawa Timur memiliki peran strategis dalam lanskap nasional dari berbagai aspek seperti demografi, ekonomi, industri, infrastruktur, politik, dan budaya.\n\n'
              'Jawa Timur tercatat sebagai destinasi utama investasi terbesar di tingkat nasional pada tahun 2022. Di tahun berikutnya, tren investasi di Jatim tumbuh 50,2% pada triwulan III 2023. Posisi ini menempatkan Jawa Timur berada di urutan ketiga nasional setelah DKI Jakarta dan Jawa Barat. Jawa Timur tumbuh dalam lingkungan yang multikultur, bukan monokultur. Budayawan Universitas Jember, Ayu Sutarto (2004), membagi Jatim menjadi sepuluh tlatah atau kawasan budaya. Pertama, kawasan budaya besar yang terdiri dari Mataraman, Arek, Madura Pulau dan Pandalungan. Kedua, tlatah kebudayaan kecil, terdiri dari Jawa Panaragan, Osing, Tengger, Madura Bawean, Madura Kangean dan Samin.\n\n'
              'Jawa Timur menyimpan warisan bersejarah dari kerajaan-kerajaan besar yang berjaya di masa silam. Kerajaan Kadiri (Panjalu) di Kota Kediri, dan Singhasari (Tumapel) yang berpusat di Malang mengawali jejak peradaban Nusantara. Puncak kejayaan ditandai dengan berdirinya Kerajaan terbesar Nusantara, berpusat di Trowulan, Mojokerto, yaitu kerajaan Majapahit. Selain dikenal dengan Sumpah Palapa dari Mahapatih Gajah Mada, Kerajaan Majapahit juga menjadi simbol persatuan dan kejayaan Nusantara. Lebih dari sekadar seni dan tradisi, masyarakat Jawa Timur menjunjung tinggi nilai kebajikan. Nilai ini tercermin dalam moto yang berbunyi Jer Basuki Mawa Beya, yang berarti bahwa setiap keberhasilan membutuhkan pengorbanan. Prinsip ini menjadi landasan semangat dan ketangguhan rakyat Jawa Timur dalam menghadapi berbagai rintangan.',
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
