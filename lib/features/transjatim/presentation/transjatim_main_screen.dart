import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:majadigi/features/transjatim/presentation/transjatim_tiket_screen.dart';
import 'package:majadigi/features/transjatim/presentation/transjatim_rute_screen.dart';

class TransJatimMainScreen extends StatelessWidget {
  const TransJatimMainScreen({Key? key}) : super(key: key);

  static const Color primaryBlue = Color(0xFF0065FF);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        _buildLogo(),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'TransJatim AJAIB 2.0',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Platform layanan bus TransJatim',
                            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.6),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildTabSelector(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildLayananTab(context),
                        _buildOperasionalTab(),
                        _buildKetentuanUmumTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'TransJatim AJAIB 2.0',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 6)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE6F0FF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              'assets/images/logo_trans_jatim.png',
              width: 72,
              height: 72,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        labelColor: primaryBlue,
        unselectedLabelColor: const Color(0xFF6B7280),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        tabs: const [
          Tab(text: 'Layanan'),
          Tab(text: 'Operasional'),
          Tab(text: 'Ketentuan Umum'),
        ],
      ),
    );
  }

  Widget _buildLayananTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionCard(
            title: 'Tiket TransJatim',
            icon: Icons.directions_bus,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TransJatimTiketScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            title: 'Rute TransJatim',
            icon: Icons.alt_route,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TransJatimRuteScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOperasionalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Link Layanan',
            content: 'https://dishub.jatimprov.go.id',
            isLink: true,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Alamat',
            content: 'Jl. Johar No.17, Alun - Alun Contong, Kec. Bubutan, Surabaya, Jawa Timur 60174',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Jam Operasional',
            content: 'Senin - Minggu: 05.00 - 21.00 WIB',
          ),
        ],
      ),
    );
  }

  Widget _buildKetentuanUmumTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExpandableCard(
            context,
            title: 'Manfaat',
            content: 'Layanan bus TransJatim menawarkan perjalanan yang aman, nyaman, dan terjangkau untuk seluruh masyarakat Jawa Timur.',
          ),
          const SizedBox(height: 16),
          _buildExpandableCard(
            context,
            title: 'Pendaftaran Online',
            content: 'Pendaftaran dan pemesanan tiket dapat dilakukan secara online melalui aplikasi ini dengan mudah dan cepat.',
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F0FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: primaryBlue, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content, bool isLink = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: isLink
                ? () async {
                    final url = Uri.parse(content);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  }
                : null,
            child: Text(
              content,
              style: TextStyle(fontSize: 14, color: isLink ? primaryBlue : const Color(0xFF334155), height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCard(BuildContext context, {required String title, required String content}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 5)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          trailing: const Icon(Icons.add, color: Colors.black87),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(content, style: const TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.6)),
            ),
          ],
        ),
      ),
    );
  }
}
