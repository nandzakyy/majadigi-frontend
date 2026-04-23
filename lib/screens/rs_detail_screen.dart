import 'package:flutter/material.dart';
import 'antrean_screen.dart';
import 'kamar_screen.dart';

class RSDetailScreen extends StatelessWidget {
  final String nama;
  final String alamat;
  final String deskripsi;
  final String linkLayanan;
  final String jamOperasional;

  const RSDetailScreen({
    super.key,
    required this.nama,
    required this.alamat,
    this.deskripsi =
        "Rumah Sakit rujukan layanan kesehatan berstatus A di Jawa Timur",
    this.linkLayanan = "https://rsudrsoetomo.jatimprov.go.id/",
    this.jamOperasional = "Senin - Minggu: 24 Jam",
  });

  @override
  Widget build(BuildContext context) {
    int selectedTabIndex = 0;

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
                  _buildLogoPlaceholder(nama),
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
                              deskripsi,
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
                            if (selectedTabIndex == 1) _operasionalTab(),
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
  Widget _buildLogoPlaceholder(String title) {
    return Column(
      children: [
        Container(width: 120, height: 120, color: Colors.grey.shade200),
        const SizedBox(height: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text("BUILD TRUST"),
      ],
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
            MaterialPageRoute(builder: (_) => const AntreanScreen()),
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
  Widget _operasionalTab() {
    return Column(
      children: [
        _detail("Link Layanan", linkLayanan),
        const SizedBox(height: 12),
        _detail("Alamat", alamat),
        const SizedBox(height: 12),
        _detail("Jam Operasional", jamOperasional),
      ],
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
