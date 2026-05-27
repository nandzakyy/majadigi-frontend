import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../../../core/utils/file_download/file_download.dart';

class TicketDetailScreen extends StatelessWidget {
  final Map<String, String> ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          CustomWaveHeader(title: "Tiket Saya", onSavePressed: () {}),
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
                      onPressed: () => _downloadTicket(context),
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
                    (ticket["name"] ?? "").toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF0044B2),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Tiket Masuk ${ticket["name"] ?? ""}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoRow(
                  Icons.person_outline,
                  "${ticket["quantity"] ?? "1"} Pengunjung",
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.calendar_today_outlined,
                  ticket["date"] ?? "",
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.access_time, "${ticket["time"] ?? ""} WIB"),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.payments_outlined,
                  "Total: Rp ${ticket["totalPayment"] ?? "0"}",
                ),
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

  Future<void> _downloadTicket(BuildContext context) async {
    try {
      final svgContent = _generateTicketSvg();
      final bytes = Uint8List.fromList(utf8.encode(svgContent));

      final name = (ticket['name'] ?? 'tiket').trim();
      final safeName = name.isEmpty
          ? 'tiket'
          : name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]+'), '-');

      await saveBytesAsFile(
        bytes: bytes,
        filename: 'tiket-$safeName.svg',
        mimeType: 'image/svg+xml;charset=utf-8',
      );

      if (context.mounted) {
        _showSuccessSnackbar(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengunduh tiket: $e')));
      }
    }
  }

  String _generateTicketSvg() {
    final name = _escapeXml(ticket['name'] ?? '-');
    final date = _escapeXml(ticket['date'] ?? '-');
    final time = _escapeXml(ticket['time'] ?? '-');
    final quantity = _escapeXml(ticket['quantity'] ?? '1');
    final total = _escapeXml(ticket['totalPayment'] ?? '0');
    final alamat = _escapeXml(ticket['alamat'] ?? '-');

    final now = _escapeXml(DateTime.now().toString().split('.').first);

    return '''
<svg xmlns="http://www.w3.org/2000/svg" width="420" height="640" viewBox="0 0 420 640">
  <rect width="420" height="640" fill="#ffffff"/>
  <rect x="20" y="20" width="380" height="600" rx="24" fill="#ffffff" stroke="#e5e5e5" stroke-width="2"/>

  <style>
    .title { font-size: 20px; font-weight: 700; fill: #111111; font-family: Arial, sans-serif; }
    .subtitle { font-size: 13px; font-weight: 700; fill: #0065FF; font-family: Arial, sans-serif; }
    .label { font-size: 12px; font-weight: 700; fill: #666666; font-family: Arial, sans-serif; }
    .value { font-size: 16px; font-weight: 700; fill: #111111; font-family: Arial, sans-serif; }
    .muted { font-size: 12px; fill: #666666; font-family: Arial, sans-serif; }
    .divider { stroke: #cfcfcf; stroke-width: 2; stroke-dasharray: 8 8; }
    .qrBox { fill: #ffffff; stroke: #e9e9e9; stroke-width: 2; }
    .qrText { font-size: 11px; fill: #999999; font-family: Arial, sans-serif; }
  </style>

  <text x="210" y="70" text-anchor="middle" class="subtitle">SIDITA</text>
  <text x="210" y="100" text-anchor="middle" class="title">Tiket Masuk</text>
  <text x="210" y="130" text-anchor="middle" class="value">$name</text>

  <line x1="60" y1="165" x2="360" y2="165" class="divider"/>

  <text x="60" y="205" class="label">Tanggal</text>
  <text x="60" y="230" class="value">$date</text>

  <text x="60" y="270" class="label">Waktu</text>
  <text x="60" y="295" class="value">$time WIB</text>

  <text x="60" y="335" class="label">Jumlah Pengunjung</text>
  <text x="60" y="360" class="value">$quantity</text>

  <text x="60" y="400" class="label">Total Pembayaran</text>
  <text x="60" y="425" class="value">Rp $total</text>

  <text x="60" y="465" class="label">Alamat</text>
  <text x="60" y="490" class="muted">$alamat</text>

  <line x1="60" y1="520" x2="360" y2="520" class="divider"/>

  <rect x="145" y="540" width="130" height="80" rx="12" class="qrBox"/>
  <text x="210" y="585" text-anchor="middle" class="qrText">QR (coming soon)</text>

  <text x="210" y="625" text-anchor="middle" class="qrText">Diunduh: $now</text>
</svg>
''';
  }

  String _escapeXml(String value) {
    return const HtmlEscape(HtmlEscapeMode.element).convert(value);
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
