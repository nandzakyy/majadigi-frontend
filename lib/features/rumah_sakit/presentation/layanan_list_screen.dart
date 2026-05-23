import 'package:flutter/material.dart';
import 'card_layanan.dart';
import '../data/rumah_sakit_data.dart';
import 'rs_detail_screen.dart';
import '../../islamic_center/presentation/islamic_center_detail_screen.dart';
import '../../sidita/presentation/sidita_screen.dart';

class LayananListScreen extends StatelessWidget {
  const LayananListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ===== DATA RS =====
    final rsList = RumahSakitData.rsList;

    return Scaffold(
      appBar: AppBar(title: const Text("Layanan"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ===== SECTION TITLE =====
            const Text(
              "Layanan Kesehatan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // ===== LIST RS (AUTO GENERATE) =====
            ...rsList.map((rs) {
              return CardLayanan(
                title: rs["nama"]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RSDetailScreen(
                        nama: rs["nama"]!,
                        alamat: rs["alamat"]!,
                        logoPath: rs["logoPath"]!,
                      ),
                    ),
                  );
                },
              );
            }),

            const SizedBox(height: 24),

            // ===== SECTION LAIN =====
            const Text(
              "Layanan Lainnya",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // ===== ISLAMIC CENTER =====
            CardLayanan(
              title: "Islamic Center",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IslamicCenterDetailScreen()),
                );
              },
            ),

            // ===== SIDITA =====
            CardLayanan(
              title: "Sidita",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SiditaScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
