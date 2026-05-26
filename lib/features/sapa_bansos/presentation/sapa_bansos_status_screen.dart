import 'package:flutter/material.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_dashboard_screen.dart';
import '../../../core/widgets/custom_wave_header.dart';

class SapaBansosStatusScreen extends StatelessWidget {
  final String nik;

  const SapaBansosStatusScreen({Key? key, required this.nik}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomWaveHeader(
            title: 'Status Kepesertaan',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status Kepesertaan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F7E9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFB7E2B9)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Status Saat Ini',
                          style: TextStyle(fontSize: 12, color: Color(0xFF2C3E50)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'AKTIF',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B7E3A),
                          ),
                        ),
                        SizedBox(height: 8),
                        Icon(Icons.check_circle, color: Color(0xFF1B7E3A), size: 28),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow('Nama', 'BUDI SANTOSO'),
                  const SizedBox(height: 12),
                  _buildDetailRow('NIK', '3273********01'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Status', 'Penerima Aktif', highlight: true),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Program Bansos',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9E9FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'PKH Plus',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Program Keluarga Harapan dengan tambahan bantuan tunai untuk lanjut usia dan penyandang disabilitas.',
                                style: TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade100),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.calendar_today, size: 16, color: Color(0xFF0065FF)),
                                  SizedBox(width: 8),
                                  Text(
                                    '10 Mei 2026',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF0065FF)),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9F3FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Akan cair',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0065FF)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosDashboardScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0065FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Lihat Dashboard',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
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

  Widget _buildDetailRow(String label, String value, {bool highlight = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: highlight ? const Color(0xFF0065FF) : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
