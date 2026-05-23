import 'package:flutter/material.dart';
import 'package:majadigi/features/sapa_bansos/presentation/sapa_bansos_pengaduan_status_screen.dart';

class SapaBansosPengaduanScreen extends StatefulWidget {
  const SapaBansosPengaduanScreen({Key? key}) : super(key: key);

  @override
  State<SapaBansosPengaduanScreen> createState() => _SapaBansosPengaduanScreenState();
}

class _SapaBansosPengaduanScreenState extends State<SapaBansosPengaduanScreen> {
  String _selectedIssue = 'Data tidak sesuai';
  final TextEditingController _nameController = TextEditingController(text: 'Budi Santoso');
  final TextEditingController _nikController = TextEditingController(text: '327101******0001');
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Jenis Masalah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildIssueChip('Data tidak sesuai'),
                      _buildIssueChip('Bantuan belum diterima'),
                      _buildIssueChip('Pencairan terlambat'),
                      _buildIssueChip('Lainnya'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildField('Nama Lengkap', controller: _nameController),
                  const SizedBox(height: 12),
                  _buildField('NIK', controller: _nikController),
                  const SizedBox(height: 12),
                  _buildField('Deskripsi Masalah', controller: _descriptionController, maxLines: 4),
                  const SizedBox(height: 12),
                  _buildField('Tanggal Kejadian', controller: _dateController, suffixIcon: Icons.calendar_today),
                  const SizedBox(height: 12),
                  _buildUploadField(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SapaBansosPengaduanStatusScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0065FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Kirim Pengaduan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0065FF),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Text('Pengaduan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildIssueChip(String label) {
    final bool selected = _selectedIssue == label;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: selected ? Colors.white : const Color(0xFF1E293B))),
      selected: selected,
      selectedColor: const Color(0xFF0065FF),
      backgroundColor: Colors.grey.shade100,
      onSelected: (_) {
        setState(() {
          _selectedIssue = label;
        });
      },
    );
  }

  Widget _buildField(String label, {required TextEditingController controller, int maxLines = 1, IconData? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Bukti', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: const [
              Icon(Icons.cloud_upload_outlined, color: Color(0xFF6B7280), size: 32),
              SizedBox(height: 10),
              Text('Upload foto atau dokumen', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              SizedBox(height: 6),
              Text('Maksimal ukuran file 5MB (JPG, PNG, PDF)', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
            ],
          ),
        ),
      ],
    );
  }
}
