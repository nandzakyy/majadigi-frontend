import 'package:flutter/material.dart';
import 'nomor_darurat_kontak_screen.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../../../core/widgets/custom_accordion_widget.dart';
import '../../../core/widgets/custom_tab_selector.dart';
import '../../../core/widgets/custom_info_card.dart';

class NomorDaruratMainScreen extends StatelessWidget {
  const NomorDaruratMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedTabIndex = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: 'Nomor Darurat',
            onSavePressed: () {},
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  
                  // Pure Jatim Logo
                  Center(
                    child: Image.asset(
                      'assets/images/logo_jawa_timur.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.location_city, size: 120, color: Colors.blue);
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nomor Darurat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              'Berisi Nomor Darurat yang dapat dihubungi oleh masyarakat',
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

  // ================= TAB: LAYANAN =================
  Widget _layananTab(BuildContext context) {
    return Column(
      children: [
        CustomInfoCard(
          icon: Icons.contact_phone,
          title: "Kontak Darurat",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NomorDaruratKontakScreen()),
            );
          },
        ),
      ],
    );
  }

  // ================= TAB: OPERASIONAL =================
  Widget _operasionalTab() {
    return Column(
      children: const [
        CustomInfoCard(
          title: "Link Layanan",
          subtitle: "https://dinsos.jatimprov.go.id",
          isLink: true,
        ),
        SizedBox(height: 12),
        CustomInfoCard(
          title: "Alamat",
          subtitle: "Seluruh Kota, Jawa Timur",
        ),
        SizedBox(height: 12),
        CustomInfoCard(
          title: "Jam Operasional",
          subtitle: "Senin - Minggu : 24 Jam",
        ),
      ],
    );
  }

  // ================= TAB: KETENTUAN =================
  Widget _ketentuanTab() {
    return Column(
      children: const [
        CustomAccordionWidget(
          title: "Manfaat",
          content: "Layanan nomor darurat memudahkan masyarakat untuk menghubungi layanan penting dengan cepat dan tepat tanpa harus mencari satu per satu nomor resmi.",
        ),
        SizedBox(height: 12),
        CustomAccordionWidget(
          title: "Ketentuan Umum",
          content: "Gunakan nomor darurat hanya untuk situasi darurat agar layanan tetap tersedia bagi yang membutuhkan. Penyalahgunaan dapat mengganggu pelayanan dan dapat dikenakan sanksi sesuai ketentuan.",
        ),
      ],
    );
  }
}
