import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../../../core/widgets/custom_accordion_widget.dart';
import '../../../core/widgets/custom_info_card.dart';
import '../../../core/widgets/custom_tab_selector.dart';
import '../data/islamic_center_data.dart';
import 'islamic_center_building_screen.dart';

class IslamicCenterDetailScreen extends StatelessWidget {
  const IslamicCenterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedTabIndex = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "Islamic Center",
            onSavePressed: () {},
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Main Logo
                  Image.asset(
                    'assets/images/Islamic_Center.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if image doesn't exist
                      return const Icon(Icons.mosque, size: 120, color: Colors.blue);
                    },
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
                              "Islamic Center",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              "Pemesan online fasilitas aula dan asrama di Islamic Center Surabaya",
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
          icon: Icons.account_balance,
          title: "Gedung Islamic Center",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const IslamicCenterBuildingScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ================= TAB: OPERASIONAL =================
  Widget _operasionalTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInfoCard(
          title: "Link Layanan",
          subtitle: IslamicCenterData.linkLayanan,
          isLink: true,
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          title: "Alamat",
          subtitle: IslamicCenterData.alamat,
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          title: "Jam Operasional",
          subtitle: IslamicCenterData.jamOperasional,
        ),
      ],
    );
  }

  // ================= TAB: KETENTUAN =================
  Widget _ketentuanTab() {
    final data = IslamicCenterData.ketentuanData;
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
