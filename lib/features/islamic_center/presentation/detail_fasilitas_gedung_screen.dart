import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';

import '../models/detail_fasilitas_gedung_model.dart';
import 'data_pemesan_screen.dart';

class DetailFasilitasGedungScreen extends StatelessWidget {
  final String subtitle;
  final List<DetailFasilitasGedungModel> facilityList;

  const DetailFasilitasGedungScreen({
    super.key,
    required this.subtitle,
    required this.facilityList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "Detail Fasilitas Gedung",
            subtitle: subtitle,
            onSavePressed: () {},
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                ...facilityList.map((detail) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildDetailCard(context, detail),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, DetailFasilitasGedungModel model) {
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
              model.image,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 180,
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
                  model.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // INFO ROW (Kapasitas & Tarif)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KAPASITAS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Kapasitas",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.people_outline, size: 16, color: Colors.black54),
                              const SizedBox(width: 6),
                              Text(
                                model.capacity,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // DIVIDER
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade300,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // TARIF
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subtitle == "Asrama" ? "Tarif per malam" : "Tarif per jam",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.account_balance_wallet_outlined, size: 16, color: Colors.black54),
                              const SizedBox(width: 6),
                              Text(
                                model.price,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataPemesanScreen(
                            model: model,
                            isAsrama: subtitle == "Asrama",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0065FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Detail Pemesanan",
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
