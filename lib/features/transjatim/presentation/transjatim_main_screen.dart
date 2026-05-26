import 'package:flutter/material.dart';
import 'transjatim_tiket_screen.dart';
import 'transjatim_rute_screen.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../../../core/widgets/custom_tab_selector.dart';
import '../../../core/widgets/custom_info_card.dart';
import '../../../core/widgets/custom_accordion_widget.dart';

class TransJatimMainScreen extends StatelessWidget {
  const TransJatimMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedTabIndex = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: 'TransJatim AJAIB 2.0',
            onSavePressed: () {},
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  
                  // Pure TransJatim Logo
                  Center(
                    child: Image.asset(
                      'assets/images/logo_trans_jatim.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.directions_bus, size: 120, color: Colors.blue);
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
                              'TransJatim AJAIB 2.0',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              'Platform layanan bus TransJatim',
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
          icon: Icons.directions_bus,
          title: "Tiket TransJatim",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransJatimTiketScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          icon: Icons.alt_route,
          title: "Rute TransJatim",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransJatimRuteScreen()),
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
          subtitle: "https://dishub.jatimprov.go.id",
          isLink: true,
        ),
        SizedBox(height: 12),
        CustomInfoCard(
          title: "Alamat",
          subtitle: "Jl. Johar No.17, Alun - Alun Contong, Kec. Bubutan, Surabaya, Jawa Timur 60174",
        ),
        SizedBox(height: 12),
        CustomInfoCard(
          title: "Jam Operasional",
          subtitle: "Senin - Minggu: 05.00 - 21.00 WIB",
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
          content: "Layanan bus TransJatim menawarkan perjalanan yang aman, nyaman, dan terjangkau untuk seluruh masyarakat Jawa Timur.",
        ),
        SizedBox(height: 12),
        CustomAccordionWidget(
          title: "Pendaftaran Online",
          content: "Pendaftaran dan pemesanan tiket dapat dilakukan secara online melalui aplikasi ini dengan mudah dan cepat.",
        ),
      ],
    );
  }
}
