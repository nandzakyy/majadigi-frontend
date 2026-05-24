import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';

class SapaBansosProgramDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String assetPath;

  const SapaBansosProgramDetailScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.assetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final details = _programDetails();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: title,
            onSavePressed: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F2FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.image_not_supported, size: 48, color: Color(0xFF0065FF)));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Syarat Penerima'),
                  const SizedBox(height: 12),
                  ...(details['requirements'] as List<String>).map<Widget>((item) => _buildBulletItem(item)).toList(),
                  const SizedBox(height: 24),
                  _buildInfoRow('Jadwal Penyaluran', details['schedule']),
                  const SizedBox(height: 16),
                  _buildInfoRow('Target Penerima', details['target']),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFD1E9FF)),
                    ),
                    child: const Text(
                      'Informasi lengkap mengenai syarat dan alur penyaluran bansos ada di website resmi SAPA BANSOS dan Dinas Sosial Provinsi Jawa Timur.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _programDetails() {
    switch (title) {
      case 'Program Keluarga Harapan Plus':
        return {
          'requirements': [
            'Terdaftar dalam DTKS dan memiliki Keluarga Penerima Manfaat (KPM).',
            'Prioritas untuk lanjut usia, penyandang disabilitas, dan ibu hamil.',
            'Memiliki kartu keluarga dan NIK yang valid.',
          ],
          'schedule': 'Penyaluran triwulanan sesuai jadwal SAPA BANSOS.',
          'target': 'Keluarga miskin dan rentan miskin di Jawa Timur.',
        };
      case 'Kemiskinan Ekstrem':
        return {
          'requirements': [
            'Keluarga teridentifikasi miskin ekstrem oleh Dinas Sosial.',
            'Tidak menerima program bantuan lain yang serupa.',
            'Memiliki NIK dan dokumen pendukung yang lengkap.',
          ],
          'schedule': 'Penyaluran triwulanan pada tahun berjalan.',
          'target': 'Keluarga miskin ekstrem yang belum menerima bantuan program lain.',
        };
      case 'Bantuan Langsung Tunai Dana Bagi Hasil Cukai Hasil Tembakau':
        return {
          'requirements': [
            'Buruh rokok atau pekerja industri hasil tembakau terdaftar.',
            'Bekerja di luar domisili sesuai ketentuan program.',
            'Memiliki dokumen pekerja dan NIK yang valid.',
          ],
          'schedule': 'Cair setiap 2 bulan sesuai jadwal penyaluran.',
          'target': 'Buruh rokok, petani tembakau, dan pelaku usaha hasil tembakau.',
        };
      case 'Asistensi Sosial Penyandang Disabilitas':
        return {
          'requirements': [
            'Terdaftar sebagai penyandang disabilitas dalam DTKS.',
            'Memiliki rekomendasi medis atau bukti disabilitas.',
            'Memiliki NIK yang valid dan dokumen pendukung.',
          ],
          'schedule': 'Penyaluran bantuan bulanan.',
          'target': 'Penyandang disabilitas dengan kebutuhan tambahan dukungan sosial.',
        };
      default:
        return {
          'requirements': ['Syarat penerima dan jadwal penyaluran ditentukan berdasarkan program.',],
          'schedule': 'Informasi penyaluran mengikuti ketentuan program.',
          'target': 'Penerima yang memenuhi kriteria program.',
        };
    }
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: const BoxDecoration(color: Color(0xFF0065FF), shape: BoxShape.circle),
          ),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.5)),
        ],
      ),
    );
  }
}
