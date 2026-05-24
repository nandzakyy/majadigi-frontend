import 'package:flutter/material.dart';
import 'package:majadigi/features/transjatim/presentation/transjatim_detail_rute_screen.dart';
import '../../../core/widgets/custom_wave_header.dart';

class TransJatimRuteScreen extends StatelessWidget {
  const TransJatimRuteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ruteList = [
      {
        'from': 'Gresik',
        'to': 'Sidoarjo via Surabaya',
        'color': Colors.blue.shade300,
        'jam': '06:00 - 18:00 WIB'
      },
      {
        'from': 'Terminal Bunder (OD)',
        'to': 'Terminal Paciran (OD)',
        'color': Colors.red.shade700,
        'jam': '06:00 - 18:00 WIB'
      },
      {
        'from': 'Surabaya',
        'to': 'Bangkalan',
        'color': Colors.green.shade700,
        'jam': '05:00 - 21:00 WIB'
      },
      {
        'from': 'Sidoarjo',
        'to': 'Mojokerto',
        'color': Colors.pink.shade300,
        'jam': '05:00 - 21:00 WIB'
      },
      {
        'from': 'Terminal Lamongan',
        'to': 'Terminal Paciran',
        'color': Colors.orange.shade700,
        'jam': '05:00 - 21:00 WIB'
      },
      {
        'from': 'Terminal Hamid Rusdi',
        'to': 'Terminal Batu',
        'color': Colors.blue.shade800,
        'jam': '05:00 - 21:00 WIB'
      },
      {
        'from': 'Sidoarjo via Surabya',
        'to': 'Gresik',
        'color': Colors.green.shade700,
        'jam': '05:00 - 21:00 WIB'
      },
      {
        'from': 'Surabaya',
        'to': 'Mojokerto',
        'color': Colors.red.shade700,
        'jam': '04:00 - 21:00 WIB'
      },
      {
        'from': 'Mojokerto',
        'to': 'Gresik',
        'color': Colors.blue.shade800,
        'jam': '05:00 - 21:00 WIB'
      },
      {
        'from': 'Gresik',
        'to': 'Lamongan',
        'color': Colors.orange.shade300,
        'jam': '05:00 - 21:00 WIB'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomWaveHeader(
            title: 'Rute TransJatim',
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              itemCount: ruteList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final rute = ruteList[index];
                return _buildRuteCard(
                  from: rute['from'],
                  to: rute['to'],
                  iconColor: rute['color'],
                  jamOperasional: rute['jam'],
                  onDetailTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransJatimDetailRuteScreen(
                          from: rute['from'],
                          to: rute['to'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuteCard({
    required String from,
    required String to,
    required Color iconColor,
    required String jamOperasional,
    required VoidCallback onDetailTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          from,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.sync_alt, color: Colors.blue, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          to,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions_bus, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jam Operasional $jamOperasional',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                GestureDetector(
                  onTap: onDetailTap,
                  child: const Text(
                    'Detail',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
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
