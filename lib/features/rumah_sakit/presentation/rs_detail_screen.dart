import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'antrean_screen.dart';
import 'kamar_screen.dart';
import '../data/rumah_sakit_data.dart';
import '../../../core/widgets/custom_wave_header.dart';

class RSDetailScreen extends StatelessWidget {

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

    final data = RumahSakitData.rsDetailData[nama] ?? {};
    final activeDeskripsi = data["deskripsi"] ?? deskripsi;
    final activeLink = data["link"] ?? linkLayanan;
    final activeAlamat = data["alamat"] ?? alamat;
    final activeJam = data["jam"] ?? jamOperasional;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: nama,
            rightWidget: GestureDetector(
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


