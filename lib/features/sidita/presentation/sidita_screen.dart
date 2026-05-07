import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/sidita_data.dart';
import 'sidita_destinasi_screen.dart';

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
          _buildHeader(context, SiditaData.headerData["title"]!),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  
                  // Content utama
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      SiditaData.headerData["mainTitle"]!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0044B2), // Biru gelap
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Gallery horizontal
                  SizedBox(
                    height: 180,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildGalleryImage('assets/images/wisata_bromo.png'),
                        const SizedBox(width: 16),
                        _buildGalleryImage('assets/images/wisata_beach.png'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          SiditaData.headerData["title"]!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          SiditaData.headerData["subtitle"]!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // TAB
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _tab("Layanan", 0),
                            _tab("Operasional", 1),
                            _tab("Ketentuan Umum", 2),
                          ],
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

  // ================= GALLERY IMAGE =================
  Widget _buildGalleryImage(String imagePath) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context, String title) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = topPadding + kToolbarHeight + 40;

    return Container(
      height: headerHeight,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Color(0xFF0065FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: _HeaderWaveClipper(),
              child: Container(
                color: const Color(0xFF005FF0),
              ),
            ),
          ),
          Positioned(
            top: topPadding + 16,
            left: 16,
            right: 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
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
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

  // ================= TAB BUTTON =================
  Widget _tab(String title, int index) {
    final active = index == selectedTabIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE8F2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? const Color(0xFF0D6EFD) : Colors.grey.shade600,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ================= TAB: LAYANAN =================
  Widget _layananTab() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SiditaDestinasiScreen()),
            );
          },
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.map, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  "SIDITA",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(color: Color(0xFFEEEEEE)),
      ],
    );
  }

  // ================= TAB: OPERASIONAL =================
  Widget _operasionalTab() {
    final data = SiditaData.operasionalData;
    return Column(
      children: [
        _detailLink("Link Layanan", data["link"]!),
        const SizedBox(height: 12),
        _detail("Alamat", data["alamat"]!),
        const SizedBox(height: 12),
        _detail("Jam Operasional", data["jam"]!),
      ],
    );
  }

  Widget _detailLink(String title, String linkUrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(linkUrl);
              try {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } catch (e) {
                // Abaikan jika error
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
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
          const SizedBox(height: 8),
          Text(content, style: TextStyle(color: Colors.grey.shade600, height: 1.4)),
        ],
      ),
    );
  }

  // ================= TAB: KETENTUAN =================
  Widget _ketentuanTab() {
    final data = SiditaData.ketentuanData;
    return Column(
      children: data.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _accordion(item["title"]!, item["content"]!),
        );
      }).toList(),
    );
  }

  Widget _accordion(String title, String content) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ExpansionTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          iconColor: Colors.black,
          collapsedIconColor: Colors.black,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(content, style: TextStyle(color: Colors.grey.shade600, height: 1.4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= CLIPPER UNTUK WAVE HEADER =================
class _HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.70);

    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.95, 
      size.width * 0.5, size.height * 0.70
    );

    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.45, 
      size.width, size.height * 0.65
    );

    path.lineTo(size.width, size.height);
    path.close(); 
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
