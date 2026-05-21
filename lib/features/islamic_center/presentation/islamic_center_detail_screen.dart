import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/custom_wave_header.dart';
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
                  // Main Logo
                  Image.asset(
                    'assets/images/Islamic_center_logo.png',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _tab("Layanan", 0, selectedTabIndex, (i) {
                                  setState(() => selectedTabIndex = i);
                                }),
                                _tab("Operasional", 1, selectedTabIndex, (i) {
                                  setState(() => selectedTabIndex = i);
                                }),
                                _tab("Ketentuan Umum", 2, selectedTabIndex, (i) {
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
        _card(context, Icons.account_balance, "Gedung Islamic Center", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IslamicCenterBuildingScreen(),
            ),
          );
        }),
      ],
    );
  }

  // ================= CARD =================
  Widget _card(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
             color: Colors.black.withOpacity(0.03),
             blurRadius: 4,
             offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14), // increased padding for the icon box as per design
              decoration: BoxDecoration(
                color: const Color(0xFFE8F2FF),
                borderRadius: BorderRadius.circular(12), // more rounded corners for inner box
              ),
              child: Icon(icon, color: Colors.black87, size: 24),
            ),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  // ================= TAB: OPERASIONAL =================
  Widget _operasionalTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detailLink("Link Layanan", IslamicCenterData.linkLayanan),
        const SizedBox(height: 12),
        _detail("Alamat", IslamicCenterData.alamat),
        const SizedBox(height: 12),
        _detail("Jam Operasional", IslamicCenterData.jamOperasional),
      ],
    );
  }

  Widget _detailLink(String title, String linkUrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                fontSize: 14,
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
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  // ================= TAB: KETENTUAN =================
  Widget _ketentuanTab() {
    return Column(
      children: const [
        _CustomAccordion(title: "Manfaat"),
        SizedBox(height: 12),
        _CustomAccordion(title: "Pendaftaran Online"),
      ],
    );
  }
}

class _CustomAccordion extends StatefulWidget {
  final String title;

  const _CustomAccordion({required this.title});

  @override
  State<_CustomAccordion> createState() => _CustomAccordionState();
}

class _CustomAccordionState extends State<_CustomAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          trailing: Icon(
            _isExpanded ? Icons.remove : Icons.add,
            color: Colors.black,
            size: 24,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Isi detail lengkap mengenai ketentuan terkait.",
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
