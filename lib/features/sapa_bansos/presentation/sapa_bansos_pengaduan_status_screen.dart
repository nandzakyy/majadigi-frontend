import 'package:flutter/material.dart';

class SapaBansosPengaduanStatusScreen extends StatelessWidget {
  const SapaBansosPengaduanStatusScreen({Key? key}) : super(key: key);

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
                children: [
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F3FF),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.check_circle_outline, size: 60, color: Color(0xFF0065FF)),
                        SizedBox(height: 20),
                        Text(
                          'Pengaduan Anda berhasil dikirim',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Terima kasih telah melaporkan kendala Anda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoTile('Nomor Tiket', '#PGD-2025-00123'),
                  const SizedBox(height: 12),
                  _buildInfoTile('Diajukan pada', '15 Jan 2025'),
                  const SizedBox(height: 24),
                  _buildProgressSteps(),
                  const SizedBox(height: 24),
                  const Text(
                    'Tanggapan Petugas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Laporan Anda sedang kami tinjau bersama dinas terkait. Mohon tunggu update selanjutnya melalui notifikasi aplikasi ini.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF4B5563), height: 1.5),
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
          const Expanded(child: Text('Status Pengaduan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
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
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)))),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildProgressSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStep('Diterima', true),
        const SizedBox(height: 8),
        _buildStep('Diproses', true),
        const SizedBox(height: 8),
        _buildStep('Selesai', false),
      ],
    );
  }

  Widget _buildStep(String label, bool completed) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: completed ? const Color(0xFF0065FF) : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(completed ? Icons.check : Icons.circle, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(fontSize: 14, color: completed ? const Color(0xFF1E293B) : const Color(0xFF6B7280))),
      ],
    );
  }
}
