import 'package:flutter/material.dart';

class SapaBansosNotificationsScreen extends StatelessWidget {
  const SapaBansosNotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildTab('Semua', selected: true),
                      const SizedBox(width: 12),
                      _buildTab('Belum Dibaca', selected: false),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildNotificationItem(
                    title: 'Bansos tahap 2 sudah cair',
                    subtitle: 'Selamat! Dana bantuan sosial untuk Program Keluarga Harapan tahap ke-2 telah dikirimkan ke rekening Anda.',
                    time: '2 jam lalu',
                    isNew: true,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationItem(
                    title: 'Data Anda perlu diperbarui',
                    subtitle: 'Harap unggah kembali foto KTP Anda yang lebih jelas untuk memproses verifikasi aplikasi bantuan sosial terbaru.',
                    time: '5 jam lalu',
                    isNew: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationItem(
                    title: 'Pendaftaran Sembako Dibuka',
                    subtitle: 'Pendaftaran program bantuan sembako mandiri kini telah dibuka untuk seluruh warga DKI Jakarta.',
                    time: '2 hari lalu',
                    isNew: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationItem(
                    title: 'Verifikasi Akun Berhasil',
                    subtitle: 'Selamat, akun SAPA BANSOS Anda telah terverifikasi secara penuh. Anda kini dapat mengajukan bantuan secara mandiri.',
                    time: '3 hari lalu',
                    isNew: false,
                  ),
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
          const Expanded(child: Text('Notifikasi', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTab(String label, {required bool selected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: selected ? const Color(0xFF0065FF) : Colors.white)),
    );
  }

  Widget _buildNotificationItem({required String title, required String subtitle, required String time, required bool isNew}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isNew ? const Color(0xFFE7F0FF) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
              if (isNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF0065FF), borderRadius: BorderRadius.circular(12)),
                  child: const Text('Baru', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.5)),
          const SizedBox(height: 10),
          Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
        ],
      ),
    );
  }
}
