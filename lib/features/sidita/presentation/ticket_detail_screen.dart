import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';

class TicketDetailScreen extends StatelessWidget {
  final String eventName;

  const TicketDetailScreen({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "Tiket Saya",
            rightWidget: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildTicketCard(context),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _showSuccessSnackbar(context),
                      icon: const Icon(
                        Icons.file_download_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Download Tiket",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0065FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
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

  Widget _buildTicketCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Part
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    eventName.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF0044B2),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tiket Masuk Pantai Hapuna",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoRow(Icons.person_outline, "3 Visitors"),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.calendar_today_outlined,
                  "Saturday, 15 June 2026",
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.access_time, "08:00 WIB"),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.payments_outlined, "Total: Rp 250,000"),
              ],
            ),
          ),

          // Divider (Dashed)
          Container(
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _dashedDivider(),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Part (QR)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // TODO: Integrasi QR dari backend
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.qr_code_2,
                      size: 150,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Scan at Entrance",
                  style: TextStyle(
                    color: Color(0xFF0065FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0065FF)),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _dashedDivider() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }

  void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFF4F8FF),
        elevation: 0,
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5EFFF)),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D6EFD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sukses",
                    style: TextStyle(
                      color: Color(0xFF0D6EFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Tiket Berhasil di Unduh.",
                    style: TextStyle(color: Color(0xFF0D6EFD), fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
