import 'package:flutter/material.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_info_program_screen.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_info_screen.dart';

class SapaBansosMainScreen extends StatelessWidget {
  const SapaBansosMainScreen({Key? key}) : super(key: key);

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
                            'Data Penerima & Info Program\nBansos (SAPA BANSOS)',
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
                            'Sistem Aplikasi Pelayanan Administrasi Bantuan Sosial',
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
                        _buildKetentuanTab(),
                      ],
                    ),
                  ),
                ],
              ),
            )
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
                    'Data Penerima & Info Program\nBansos (SAPA BANSOS)',
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
        child: Image.asset(
          'assets/images/logo_jawa_timur.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.location_city, size: 80, color: primaryBlue);
          },
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
          _buildOptionCard(
            title: 'Cek Data Penerima Bansos',
            subtitle: 'Masukkan NIK untuk melihat status, program, dan riwayat bantuan Anda.',
            icon: Icons.search,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosInfoScreen()));
            },
          ),
          const SizedBox(height: 16),
          _buildOptionCard(
            title: 'Lihat Informasi Program',
            subtitle: 'Telusuri semua jenis bantuan sosial yang tersedia di SAPA BANSOS.',
            icon: Icons.info,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosInfoProgramScreen()));
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
          _buildInfoTile(
            label: 'Link Layanan',
            content: 'https://sapabansos.dinsos.jatimprov.go.id/',
          ),
          const SizedBox(height: 16),
          _buildInfoTile(
            label: 'Alamat',
            content: 'Jl. Gayung Kebonsari No.56b, Gayungan, Kec. Gayungan, Kota Surabaya, Jawa Timur 60235',
          ),
          const SizedBox(height: 16),
          _buildInfoTile(
            label: 'Jam Operasional',
            content: 'Senin - Minggu : 24 Jam',
          ),
        ],
      ),
    );
  }

  Widget _buildKetentuanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Column(
        children: [
          _buildExpansionCard(
            title: 'Manfaat',
            content:
                'Sapa Bansos memudahkan warga Jatim mengakses info program bansos, jadwal pencairan, dan daftar penerima dana secara real-time, transparan, dan akuntabel.',
          ),
          const SizedBox(height: 16),
          _buildExpansionCard(
            title: 'Pendaftaran Online',
            content:
                'a. Penerima bansos terdaftar dalam Data Terpadu Kesejahteraan Sosial (DTKS).\nb. Penerima bansos memenuhi kriteria sosial ekonomi tertentu seperti keluarga miskin atau rentan miskin, lanjut usia, dan penyandang disabilitas berat.\nc. Punya Nomor Induk Kependudukan (NIK) yang valid untuk validasi data penerima.\nd. Tidak berstatus sebagai Aparatur Sipil Negara (ASN), TNI, atau Polri.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({required String label, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.6),
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 5)),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        collapsedIconColor: primaryBlue,
        iconColor: primaryBlue,
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F2FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: primaryBlue, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 8),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.4)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}
