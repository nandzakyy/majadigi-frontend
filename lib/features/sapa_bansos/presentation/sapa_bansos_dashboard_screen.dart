import 'package:flutter/material.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_tracking_screen.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_info_program_screen.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_pengaduan_screen.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_notifications_screen.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_history_screen.dart';

class SapaBansosDashboardScreen extends StatelessWidget {
  const SapaBansosDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  _buildActionGrid(context),
                  const SizedBox(height: 24),
                  _buildHistorySection(context),
                  const SizedBox(height: 24),
                  _buildNotificationSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0065FF),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Dashboard Personal',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2574E8),
            ),
            child: const Center(
              child: Text('BS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Halo, Budi Santoso',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Berikut status bantuan Anda saat ini',
            style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F3FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Jenis Bansos', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                      SizedBox(height: 8),
                      Text('PKH Plus', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F9E8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Penerima Aktif', style: TextStyle(color: Color(0xFF1B7E3A), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: [
        _buildActionTile(
          imageAsset: 'assets/images/tracking.png',
          label: 'Tracking Penyaluran',
          color: const Color(0xFFE9F3FF),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosTrackingScreen())),
        ),
        _buildActionTile(
          imageAsset: 'assets/images/riwayat.png',
          label: 'Riwayat',
          color: const Color(0xFFE8F8FF),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosHistoryScreen())),
        ),
        _buildActionTile(
          imageAsset: 'assets/images/pengaduan.png',
          label: 'Pengaduan',
          color: const Color(0xFFFFEAF0),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosPengaduanScreen())),
        ),
        _buildActionTile(
          imageAsset: 'assets/images/info_program.png',
          label: 'Info Program',
          color: const Color(0xFFFFF3E0),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosInfoProgramScreen())),
        ),
      ],
    );
  }

  Widget _buildActionTile({required String imageAsset, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(imageAsset, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Riwayat Bantuan', onViewAll: () {}),
        const SizedBox(height: 12),
        _buildHistoryCard(title: 'PKH Plus', subtitle: 'Januari 2024', status: 'Berhasil'),
        const SizedBox(height: 12),
        _buildHistoryCard(title: 'PKH Plus', subtitle: 'Desember 2023', status: 'Berhasil'),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onViewAll}) {
    return Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
        GestureDetector(
          onTap: onViewAll,
          child: const Text('Lihat Semua', style: TextStyle(fontSize: 12, color: Color(0xFF0065FF), fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildHistoryCard({required String title, required String subtitle, required String status}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F3FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/pkh_plus.png', fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0065FF))),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Notifikasi', onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosNotificationsScreen()))),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Bansos tahap 2 sudah cair', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              SizedBox(height: 8),
              Text('Silakan cek rekening bank Himbaro Anda untuk verifikasi dana masuk.', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.4)),
              SizedBox(height: 8),
              Text('10 menit yang lalu', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
            ],
          ),
        ),
      ],
    );
  }
}
