import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';

class SapaBansosHistoryScreen extends StatelessWidget {
  const SapaBansosHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomWaveHeader(
            title: 'Riwayat',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Riwayat Pengajuan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 16),
                  _buildHistoryItem('PKH Plus', 'Januari 2024', 'Berhasil'),
                  const SizedBox(height: 12),
                  _buildHistoryItem('PKH Plus', 'Desember 2023', 'Berhasil'),
                  const SizedBox(height: 12),
                  _buildHistoryItem('Pengaduan Status', '15 Jan 2025', 'Diproses'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, String date, String status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: const Color(0xFFE9F3FF), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.history, color: Color(0xFF0065FF)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFE9F3FF), borderRadius: BorderRadius.circular(12)),
            child: Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0065FF))),
          ),
        ],
      ),
    );
  }
}
