import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../data/islamic_center_data.dart';
import '../models/detail_fasilitas_gedung_model.dart';
import 'detail_fasilitas_gedung_screen.dart';

class IslamicCenterBuildingScreen extends StatelessWidget {
  const IslamicCenterBuildingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "Gedung Islamic Center",
            onSavePressed: () {},
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // TOP SECTION
                const Text(
                  "ISLAMIC CENTER JAWA TIMUR",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Dengan fasilitas terbaik, lokasi yang mudah dijangkau, dan kemudahan proses pemesanan, kami hadir untuk memenuhi segala kebutuhan acara Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                // SECTION TITLE
                const Text(
                  "Fasilitas Gedung",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // CARDS
                ...IslamicCenterData.fasilitasGedungList.map((fasilitas) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildFacilityCard(
                      context,
                      title: fasilitas.nama,
                      description: fasilitas.deskripsi,
                      tags: fasilitas.tags,
                      imagePath: fasilitas.imagePath,
                      onTap: () {
                        List<DetailFasilitasGedungModel>? list;
                        if (fasilitas.nama == "Ruangan Masjid") {
                          list = IslamicCenterData.ruanganMasjidList;
                        } else if (fasilitas.nama == "Aula") {
                          list = IslamicCenterData.aulaList;
                        } else if (fasilitas.nama == "Asrama") {
                          list = IslamicCenterData.asramaList;
                        }

                        if (list != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailFasilitasGedungScreen(
                                subtitle: fasilitas.nama,
                                facilityList: list!,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Detail belum tersedia"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    ),
                  );
                }),
                const SizedBox(height: 8),

                // BOTTOM INFO CARD
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.info, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Sumber Data : Islamic Center Surabaya Jawa Timur",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(
    BuildContext context, {
    required String title,
    required String description,
    required List<String> tags,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE PLACEHOLDER
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 160,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // DESCRIPTION
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // TAGS
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F2FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Lihat Detail",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
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
}
