import 'package:flutter/material.dart';
import '../widgets/card_layanan.dart';
import 'rs_detail_screen.dart';
import 'darurat_screen.dart';

class LayananListScreen extends StatelessWidget {
  const LayananListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ===== DATA RS =====
    final List<Map<String, String>> rsList = [
      {"nama": "RSUD Dr Soetomo", "alamat": "Surabaya"},
      {"nama": "RSUD Karsa Husada", "alamat": "Malang"},
      {"nama": "RSUD Dr Saiful Anwar", "alamat": "Malang"},
      {"nama": "RSUD Haji Prov. Jatim", "alamat": "Surabaya"},
      {"nama": "RSUD Daha Husada", "alamat": "Kediri"},
    ];

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

            // ===== DARURAT =====
            CardLayanan(
              title: "Nomor Darurat",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DaruratScreen()),
                );
              },
            ),

            // ===== SIDITA =====
            CardLayanan(
              title: "Sidita",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sidita belum dibuat")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
