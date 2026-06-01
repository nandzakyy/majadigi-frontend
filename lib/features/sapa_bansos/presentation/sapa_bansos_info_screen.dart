import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_program_detail_screen.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_status_screen.dart';
import '../../../core/widgets/custom_wave_header.dart';

class SapaBansosInfoScreen extends StatefulWidget {
  const SapaBansosInfoScreen({Key? key}) : super(key: key);

  @override
  State<SapaBansosInfoScreen> createState() => _SapaBansosInfoScreenState();
}

class _SapaBansosInfoScreenState extends State<SapaBansosInfoScreen> {
  final TextEditingController _nikController = TextEditingController();

  final FocusNode _nikFocusNode = FocusNode();
  String? _nikErrorText;

  @override
  void initState() {
    super.initState();
    _nikFocusNode.addListener(_onNikFocusChange);
  }

  void _onNikFocusChange() {
    if (!_nikFocusNode.hasFocus) {
      final nik = _nikController.text.trim();
      if (nik.isEmpty) {
        setState(() {
          _nikErrorText = 'Silakan masukkan NIK terlebih dahulu';
        });
      } else if (nik.length != 16) {
        setState(() {
          _nikErrorText = 'NIK harus tepat 16 digit';
        });
      } else {
        setState(() {
          _nikErrorText = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _nikFocusNode.removeListener(_onNikFocusChange);
    _nikFocusNode.dispose();
    _nikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: 'Sapa Bansos',
            onSavePressed: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCheckCard(context),
                  const SizedBox(height: 32),
                  const Text(
                    'Informasi Program',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 16),
                  _buildProgramCard(
                    context: context,
                    title: 'Program Keluarga Harapan Plus',
                    description: 'Bantuan sosial bersyarat untuk kesejahteraan lansia dari keluarga penerima manfaat PKH Reguler.',
                    badge: 'PKH Plus',
                    assetPath: 'assets/images/logo_pkhp.png',
                  ),
                  _buildProgramCard(
                    context: context,
                    title: 'Kemiskinan Ekstrem',
                    description: 'Bantuan tunai langsung untuk modal usaha dan meringankan beban hidup masyarakat miskin ekstrem.',
                    badge: 'Kemiskinan Ekstrem',
                    assetPath: 'assets/images/logo_kemiskinan_ekstreme.png',
                  ),
                  _buildProgramCard(
                    context: context,
                    title: 'Bantuan Langsung Tunai Dana Bagi Hasil Cukai Hasil Tembakau',
                    description: 'Bantuan tunai bagi buruh pabrik rokok yang bekerja di luar domisili KTP (lintas wilayah).',
                    badge: 'BLT',
                    assetPath: 'assets/images/bantuan_langsung_tunai_dbh_cht.png',
                  ),
                  _buildProgramCard(
                    context: context,
                    title: 'Asistensi Sosial Penyandang Disabilitas',
                    description: 'Bantuan sosial untuk memenuhi kebutuhan dasar dan meningkatkan kualitas hidup penyandang disabilitas.',
                    badge: 'Disabilitas',
                    assetPath: 'assets/images/asistensi_sosial_penyandang_disabilitas.png',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildCheckCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cek Data Penerima Bansos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Masukkan NIK untuk mengetahui informasi penerimaan secara akurat dan cepat.',
            style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.5),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nikController,
            keyboardType: TextInputType.number,
            focusNode: _nikFocusNode,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            decoration: InputDecoration(
              hintText: 'Masukan NIK',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              errorText: _nikErrorText,
              errorStyle: const TextStyle(color: Colors.red),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFF0065FF), width: 1.5)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final nik = _nikController.text.trim();
                if (nik.isEmpty) {
                  setState(() {
                    _nikErrorText = 'Silakan masukkan NIK terlebih dahulu';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan masukkan NIK terlebih dahulu')));
                  return;
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(nik)) {
                  setState(() {
                    _nikErrorText = 'NIK harus berupa angka saja';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('NIK harus berupa angka saja')));
                  return;
                }
                if (nik.length != 16) {
                  setState(() {
                    _nikErrorText = 'NIK harus tepat 16 digit';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('NIK harus tepat 16 digit')));
                  return;
                }
                setState(() {
                  _nikErrorText = null;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SapaBansosStatusScreen(nik: nik)),
                );
              },
              icon: const Icon(Icons.search, color: Colors.white, size: 20),
              label: const Text('Cari', style: TextStyle(color: Colors.white, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0065FF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramCard({
    required BuildContext context,
    required String title,
    required String description,
    required String badge,
    required String assetPath,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SapaBansosProgramDetailScreen(
              title: title,
              description: description,
              assetPath: assetPath,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: const Color(0xFFE7F2FF), borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image, color: Color(0xFF0065FF));
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50))),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.4)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
              child: Text(badge, style: const TextStyle(fontSize: 10, color: Color(0xFF0065FF), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
