import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../models/detail_fasilitas_gedung_model.dart';

class DataPemesanScreen extends StatefulWidget {
  final DetailFasilitasGedungModel model;
  final bool isAsrama;

  const DataPemesanScreen({
    super.key,
    required this.model,
    required this.isAsrama,
  });

  @override
  State<DataPemesanScreen> createState() => _DataPemesanScreenState();
}

class _DataPemesanScreenState extends State<DataPemesanScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedWaktu; // 'Siang' or 'Malam'

  bool get _isFormValid {
    if (widget.isAsrama) {
      return _namaController.text.trim().isNotEmpty &&
          _dateController.text.trim().isNotEmpty;
    }
    return _namaController.text.trim().isNotEmpty &&
        _dateController.text.trim().isNotEmpty &&
        _selectedWaktu != null;
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _namaController.addListener(_updateState);
    _dateController.addListener(_updateState);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0065FF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final day = picked.day.toString().padLeft(2, '0');
        final month = picked.month.toString().padLeft(2, '0');
        final year = picked.year.toString();
        _dateController.text = "$day/$month/$year";
      });
    }
  }

  Future<void> _submitPesan() async {
    if (!_isFormValid) return;

    final String nama = _namaController.text.trim();
    final String tanggal = _dateController.text.trim();
    final isAsrama = widget.isAsrama;
    final String waktuText = isAsrama ? "" : "\n\nWaktu:\n${_selectedWaktu!}";

    final String pesan = '''Assalamu'alaikum,
Saya ingin melakukan pemesanan fasilitas Islamic Center.

Fasilitas:
${widget.model.title}

Nama:
$nama

Tanggal:
$tanggal$waktuText''';

    final String encodedMessage = Uri.encodeComponent(pesan);
    final Uri whatsappUrl = Uri.parse("https://wa.me/6281234567890?text=$encodedMessage");

    try {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal membuka WhatsApp")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleLower = widget.model.title.toLowerCase();
    final hideDetailFasilitas = titleLower.contains('masjid') || titleLower.contains('akad nikah');
    final isAsrama = widget.isAsrama;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "Data Pemesan",
            onSavePressed: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pastikan anda mengisi data pemesanan\ndengan benar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // DETAIL CARD
                  Container(
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
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            widget.model.image,
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
                              Text(
                                widget.model.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                              widget.model.capacity,
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
                                          widget.isAsrama
                                              ? "Tarif per malam"
                                              : "Tarif per jam",
                                          style: const TextStyle(
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
                                              widget.model.price,
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
                              const Text(
                                "Deskripsi",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.model.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // FORM SECTION
                  _buildLabel("Nama Lengkap"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      hintText: "Masukkan nama lengkap",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildLabel(isAsrama ? "Tanggal Booking" : "Waktu"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      hintText: "dd/mm/yyyy",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (!isAsrama) ...[
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: 'Siang',
                              groupValue: _selectedWaktu,
                              activeColor: Colors.pinkAccent,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedWaktu = value;
                                });
                              },
                            ),
                            const Text(
                              "Siang (09.00-15.00)",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: 'Malam',
                              groupValue: _selectedWaktu,
                              activeColor: Colors.pinkAccent,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedWaktu = value;
                                });
                              },
                            ),
                            const Text(
                              "Malam (18.00-22.00)",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (!hideDetailFasilitas) ...[
                    _buildLabel("Detail Fasilitas"),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                      child: Builder(
                        builder: (context) {
                          final isAsrama = widget.isAsrama;
                          final listFasilitas = isAsrama
                              ? ['AC', 'TV', 'Meja', 'Toilet Luar']
                              : [
                                  'Karpet',
                                  'Meja & kursi penerima tamu',
                                  'Kamar rias',
                                  'Kursi',
                                  'Genset',
                                  'AC',
                                ];
                          return Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            children: listFasilitas.map((item) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF0065FF),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // BUTTONS ROW
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Batal",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isFormValid ? _submitPesan : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0065FF),
                            disabledBackgroundColor: Colors.grey.shade300,
                            disabledForegroundColor: Colors.white,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Pesan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        children: const [
          TextSpan(
            text: "*",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
