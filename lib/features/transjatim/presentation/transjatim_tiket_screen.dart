import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';

class TransJatimTiketScreen extends StatelessWidget {
  const TransJatimTiketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomWaveHeader(
            title: 'Tiket TransJatim',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Umum',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTiketCard(
                    icon: Icons.people_outline,
                    title: 'Umum',
                    price: 'Rp2.500',
                  ),
                  const SizedBox(height: 12),
                  _buildTiketCard(
                    icon: Icons.people_outline,
                    title: 'Umum',
                    price: 'Rp5.000',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Luxury',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTiketCard(
                    icon: Icons.directions_bus,
                    title: 'SBY - SDA Umum',
                    price: 'Rp15.000',
                  ),
                  const SizedBox(height: 12),
                  _buildTiketCard(
                    icon: Icons.directions_bus,
                    title: 'SBY - GSK Umum',
                    price: 'Rp20.000',
                  ),
                  const SizedBox(height: 12),
                  _buildTiketCard(
                    icon: Icons.directions_bus,
                    title: 'SDA - GSK Umum',
                    price: 'Rp30.000',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTiketCard({required IconData icon, required String title, required String price}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0D6EFD)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const TextSpan(
                  text: '/Tiket',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
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
