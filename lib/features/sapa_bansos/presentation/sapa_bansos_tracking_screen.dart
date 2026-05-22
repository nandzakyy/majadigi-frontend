import 'package:flutter/material.dart';

class SapaBansosTrackingScreen extends StatelessWidget {
  const SapaBansosTrackingScreen({Key? key}) : super(key: key);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tracking Penyaluran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 16),
                  _buildStepper(),
                  const SizedBox(height: 24),
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  const Text('Riwayat Aktivitas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 16),
                  _buildActivityItem('Data Terdaftar di Sistem', '10 April 2026, 09:45 WIB', 'Pendaftaran melalui aplikasi SAPA BANSOS.'),
                  const SizedBox(height: 16),
                  _buildActivityItem('Verifikasi Dokumen Berhasil', '12 April 2026, 14:20 WIB', 'NIK dan KK telah tervalidasi dengan data Dukcapil.'),
                  const SizedBox(height: 16),
                  _buildActivityItem('Proses Persetujuan Bantuan', 'Sedang diproses', 'Menunggu penetapan daftar penerima bantuan oleh Kemensos.'),
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
            child: Text('Tracking Penyaluran', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStep('Terdafar', true),
          _buildStep('Verifikasi', true),
          _buildStep('Disetujui', true),
          _buildStep('Pencairan', false),
          _buildStep('Selesai', false),
        ],
      ),
    );
  }

  Widget _buildStep(String title, bool active) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF22C55E) : Colors.white,
            border: Border.all(color: active ? const Color(0xFF22C55E) : Colors.grey.shade300),
            shape: BoxShape.circle,
          ),
          child: Icon(active ? Icons.check : Icons.lock, color: active ? Colors.white : Colors.grey, size: 18),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: active ? const Color(0xFF22C55E) : Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD1E9FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Sedang Verifikasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          SizedBox(height: 8),
          Text('Data Anda sedang dalam proses verifikasi oleh sistem pusat. Mohon tunggu informasi selanjutnya pada halaman ini.', style: TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String date, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(color: Color(0xFF0065FF), shape: BoxShape.circle),
            ),
            Container(width: 2, height: 80, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 8),
                Text(date, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
