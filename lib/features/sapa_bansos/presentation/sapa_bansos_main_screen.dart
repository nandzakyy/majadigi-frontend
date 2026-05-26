import 'package:flutter/material.dart';
import 'sapa_bansos_info_screen.dart';
import 'sapa_bansos_info_program_screen.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../../../core/widgets/custom_tab_selector.dart';
import '../../../core/widgets/custom_info_card.dart';
import '../../../core/widgets/custom_accordion_widget.dart';

class SapaBansosMainScreen extends StatelessWidget {
  const SapaBansosMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedTabIndex = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: 'Sapa Bansos',
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
                      'assets/images/sapa_bansos.png',
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
                              'Sapa Bansos',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              'Sistem Aplikasi Pelayanan Administrasi Bantuan Sosial',
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
          icon: Icons.search,
          title: "Cek Data Penerima Bansos",
          subtitle: "Masukkan NIK untuk melihat status, program, dan riwayat bantuan Anda.",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SapaBansosInfoScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          icon: Icons.info,
          title: "Lihat Informasi Program",
          subtitle: "Telusuri semua jenis bantuan sosial yang tersedia di SAPA BANSOS.",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SapaBansosInfoProgramScreen()),
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
          subtitle: "https://sapabansos.dinsos.jatimprov.go.id/",
          isLink: true,
        ),
        SizedBox(height: 12),
        CustomInfoCard(
          title: "Alamat",
          subtitle: "Jl. Gayung Kebonsari No.56b, Gayungan, Kec. Gayungan, Kota Surabaya, Jawa Timur 60235",
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
          content: "Sapa Bansos memudahkan warga Jatim mengakses info program bansos, jadwal pencairan, dan daftar penerima dana secara real-time, transparan, dan akuntabel.",
        ),
        SizedBox(height: 12),
        CustomAccordionWidget(
          title: "Pendaftaran Online",
          content: "a. Penerima bansos terdaftar dalam Data Terpadu Kesejahteraan Sosial (DTKS).\nb. Penerima bansos memenuhi kriteria sosial ekonomi tertentu seperti keluarga miskin atau rentan miskin, lanjut usia, dan penyandang disabilitas berat.\nc. Punya Nomor Induk Kependudukan (NIK) yang valid untuk validasi data penerima.\nd. Tidak berstatus sebagai Aparatur Sipil Negara (ASN), TNI, atau Polri.",
        ),
      ],
    );
  }
}
