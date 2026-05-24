import 'package:flutter/material.dart';
import '../data/sidita_data.dart';
import 'sidita_destinasi_screen.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../../../core/widgets/custom_accordion_widget.dart';
import '../../../core/widgets/custom_tab_selector.dart';
import '../../../core/widgets/custom_info_card.dart';

class SiditaScreen extends StatefulWidget {
  const SiditaScreen({super.key});

  @override
  State<SiditaScreen> createState() => _SiditaScreenState();
}

class _SiditaScreenState extends State<SiditaScreen> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: SiditaData.headerData["title"]!,
            onSavePressed: () {},
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  
                  // Logo Sidita
                  Center(
                    child: Image.asset(
                      'assets/images/Sidita.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.map, size: 120, color: Colors.blue);
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          SiditaData.headerData["title"]!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          SiditaData.headerData["subtitle"]!,
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

                        if (selectedTabIndex == 0) _layananTab(),
                        if (selectedTabIndex == 1) _operasionalTab(),
                        if (selectedTabIndex == 2) _ketentuanTab(),

                        const SizedBox(height: 32),
                      ],
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
  Widget _layananTab() {
    return Column(
      children: [
        CustomInfoCard(
          icon: Icons.map,
          title: "SIDITA",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SiditaDestinasiScreen()),
            );
          },
        ),
      ],
    );
  }

  // ================= TAB: OPERASIONAL =================
  Widget _operasionalTab() {
    final data = SiditaData.operasionalData;
    return Column(
      children: [
        CustomInfoCard(
          title: "Link Layanan",
          subtitle: data["link"]!,
          isLink: true,
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          title: "Alamat",
          subtitle: data["alamat"]!,
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          title: "Jam Operasional",
          subtitle: data["jam"]!,
        ),
      ],
    );
  }

  // ================= TAB: KETENTUAN =================
  Widget _ketentuanTab() {
    final data = SiditaData.ketentuanData;
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


