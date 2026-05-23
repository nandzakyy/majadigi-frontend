import 'package:flutter/material.dart';
import 'antrean_screen.dart';
import 'kamar_screen.dart';
import '../data/rumah_sakit_data.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../../../core/widgets/custom_accordion_widget.dart';
import '../../../core/widgets/custom_tab_selector.dart';
import '../../../core/widgets/custom_info_card.dart';

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
            onSavePressed: () {},
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
                            CustomTabSelector(
                              tabs: const ["Layanan", "Operasional", "Ketentuan Umum"],
                              selectedIndex: selectedTabIndex,
                              onChanged: (index) {
                                setState(() {
                                  selectedTabIndex = index;
                                });
                              },
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



  // ================= TAB: LAYANAN =================
  Widget _layananTab(BuildContext context) {
    return Column(
      children: [
        CustomInfoCard(
          icon: Icons.people,
          title: "Informasi Antrean Pasien",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AntreanScreen(namaRS: nama)),
            );
          },
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          icon: Icons.bed,
          title: "Ketersediaan Kamar Rawat",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KamarScreen()),
            );
          },
        ),
      ],
    );
  }

  // ================= TAB: OPERASIONAL =================
  Widget _operasionalTab(String activeLink, String activeAlamat, String activeJam) {
    return Column(
      children: [
        CustomInfoCard(
          title: "Link Layanan",
          subtitle: activeLink,
          isLink: true,
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          title: "Alamat",
          subtitle: activeAlamat,
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          title: "Jam Operasional",
          subtitle: activeJam,
        ),
      ],
    );
  }

  // ================= TAB: KETENTUAN =================
  Widget _ketentuanTab() {
    final data = RumahSakitData.ketentuanData;
    return Column(
      children: data.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomAccordionWidget(
            title: item["title"]!,
            content: item["content"]!,
          ),
        );
      }).toList(),
    );
  }
}


