import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'antrean_screen.dart';
import 'kamar_screen.dart';

class RSDetailScreen extends StatelessWidget {
  final Map<String, Map<String, String>> rsData = const {
    "RSUD Dr Soetomo": {
      "deskripsi": "Rumah Sakit rujukan layanan kesehatan berstatus A di Jawa Timur",
      "link": "https://rsudrsoetomo.jatimprov.go.id/",
      "alamat": "Jl. Mayjend. Prof. Dr. Moestopo No. 6-8, Kec. Gubeng, Surabaya",
      "jam": "Senin - Minggu: 24 Jam",
    },
    "RSUD Daha Husada": {
      "deskripsi": "RSUD Daha Husada Kota Kediri",
      "link": "https://rsuddahahusada.jatimprov.go.id/",
      "alamat": "Jl. Veteran No.48, Mojoroto, Kediri",
      "jam": "Senin - Jumat: 07.00 - 21.00 WIB",
    },
    "RSUD Haji Prov. Jatim": {
      "deskripsi": "Rumah sakit tipe B pendidikan milik Pemerintah Provinsi Jawa Timur dengan status BLUD",
      "link": "https://app.rsuhaji.jatimprov.go.id/online/",
      "alamat": "Jl. Manyar Kertoadi, Sukolilo, Surabaya",
      "jam": "Senin - Minggu: 24 Jam",
    },
    "RSUD Dr Saiful Anwar": {
      "deskripsi": "RSUD DR. Saiful Anwar Provinsi Jawa Timur",
      "link": "https://rsusaifulanwar.jatimprov.go.id/v2/",
      "alamat": "Jl. Jaksa Agung Suprapto No.2, Malang",
      "jam": "Senin - Minggu: 24 Jam",
    },
    "RSUD Karsa Husada": {
      "deskripsi": "Rumah sakit tipe B yang melayani masyarakat di Kota Batu, Jawa Timur",
      "link": "https://rsukarsahusadabatu.jatimprov.go.id/",
      "alamat": "Jl. A. Yani No.10-13, Batu",
      "jam": "Senin - Minggu: 24 Jam",
    },
  };

  final String nama;
  final String alamat;
  final String deskripsi;
  final String linkLayanan;
  final String jamOperasional;
  final String logoPath;

  const RSDetailScreen({
    super.key,
    required this.nama,
    required this.alamat,
    required this.logoPath,
    this.deskripsi =
        "Rumah Sakit rujukan layanan kesehatan berstatus A di Jawa Timur",
    this.linkLayanan = "https://rsudrsoetomo.jatimprov.go.id/",
    this.jamOperasional = "Senin - Minggu: 24 Jam",
  });

  @override
  Widget build(BuildContext context) {
    int selectedTabIndex = 0;

    final data = rsData[nama] ?? {};
    final activeDeskripsi = data["deskripsi"] ?? deskripsi;
    final activeLink = data["link"] ?? linkLayanan;
    final activeAlamat = data["alamat"] ?? alamat;
    final activeJam = data["jam"] ?? jamOperasional;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context, nama),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  _buildLogo(logoPath),
                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nama,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              activeDeskripsi,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // TAB
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _tab("Layanan", 0, selectedTabIndex, (i) {
                                  setState(() => selectedTabIndex = i);
                                }),
                                _tab("Operasional", 1, selectedTabIndex, (i) {
                                  setState(() => selectedTabIndex = i);
                                }),
                                _tab("Ketentuan Umum", 2, selectedTabIndex, (
                                  i,
                                ) {
                                  setState(() => selectedTabIndex = i);
                                }),
                              ],
                            ),

                            const SizedBox(height: 24),

                            if (selectedTabIndex == 0) _layananTab(context),
                            if (selectedTabIndex == 1) _operasionalTab(activeLink, activeAlamat, activeJam),
                            if (selectedTabIndex == 2) _ketentuanTab(),

                            const SizedBox(height: 32),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context, String title) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = topPadding + kToolbarHeight + 40;

    return Container(
      height: headerHeight,
      // clipBehavior memastikan wave tidak keluar dari radius border container utama
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Color(0xFF0065FF), // Warna Biru Base (Bagian Atas) - 0065FF
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          // Warna Biru Wave (Bagian Bawah)
          Positioned.fill(
            child: ClipPath(
              clipper: _HeaderWaveClipper(),
              child: Container(
                color: const Color(0xFF005FF0), // Warna Biru pekat (Bagian Bawah) - 005FF0
              ),
            ),
          ),

          // Konten Header
          Positioned(
            top: topPadding + 16,
            left: 16,
            right: 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Back Button (Kiri)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                ),

                // Title (Tengah)
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Bookmark Icon (Kanan)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bookmark_border, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOGO =================
  Widget _buildLogo(String logoPath) {
    return Image.asset(
      logoPath,
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }

  // ================= TAB BUTTON =================
  Widget _tab(String title, int index, int selected, Function(int) onTap) {
    final active = index == selected;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE8F2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? const Color(0xFF0D6EFD) : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ================= TAB: LAYANAN =================
  Widget _layananTab(BuildContext context) {
    return Column(
      children: [
        _card(context, Icons.people, "Informasi Antrean Pasien", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AntreanScreen(namaRS: nama)),
          );
        }),
        const SizedBox(height: 16),
        _card(context, Icons.bed, "Ketersediaan Kamar Rawat", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KamarScreen()),
          );
        }),
      ],
    );
  }

  // ================= CARD =================
  Widget _card(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [Icon(icon), const SizedBox(width: 12), Text(title)],
        ),
      ),
    );
  }

  // ================= TAB: OPERASIONAL =================
  Widget _operasionalTab(String activeLink, String activeAlamat, String activeJam) {
    return Column(
      children: [
        _detailLink("Link Layanan", activeLink),
        const SizedBox(height: 12),
        _detail("Alamat", activeAlamat),
        const SizedBox(height: 12),
        _detail("Jam Operasional", activeJam),
      ],
    );
  }

  Widget _detailLink(String title, String linkUrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(linkUrl);
              try {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } catch (e) {
                // Abaikan jika tidak bisa dibuka
              }
            },
            child: Text(
              linkUrl,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }

  // ================= TAB: KETENTUAN =================
  Widget _ketentuanTab() {
    return Column(
      children: [
        _accordion("Manfaat"),
        const SizedBox(height: 12),
        _accordion("Pendaftaran Online"),
      ],
    );
  }

  Widget _accordion(String title) {
    return ExpansionTile(
      title: Text(title),
      children: const [
        Padding(padding: EdgeInsets.all(16), child: Text("Isi detail...")),
      ],
    );
  }
}

// ================= CLIPPER UNTUK WAVE HEADER =================
class _HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height); // Kiri bawah
    path.lineTo(0, size.height * 0.70); // Titik awal lengkungan di kiri

    // Lengkungan pertama: Cekung ke arah bawah (menukik ke bawah lalu ke tengah sedikit naik)
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.95, 
      size.width * 0.5, size.height * 0.70
    );

    // Lengkungan kedua: Cembung ke arah atas (naik lalu turun sedikit ke kanan tepi)
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.45, 
      size.width, size.height * 0.65
    );

    path.lineTo(size.width, size.height); // Tarik ke pojok kanan bawah
    path.close(); 
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true; // Supaya realtime kalau height layar berubah
}
