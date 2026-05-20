import 'package:flutter/material.dart';
import 'data_pasien_screen.dart';
import '../data/rumah_sakit_data.dart';
import '../../../core/widgets/custom_wave_header.dart';

class AntreanScreen extends StatefulWidget {
  final String namaRS;
  const AntreanScreen({super.key, required this.namaRS});

  @override
  State<AntreanScreen> createState() => _AntreanScreenState();
}

class _AntreanScreenState extends State<AntreanScreen> {
  String? _selectedPoli;
  String? _selectedDokter;
  DateTime? _selectedDate;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header biru melengkung
          CustomWaveHeader(
            title: "Informasi Antrean Pasien",
            rightWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bookmark_add_outlined, color: Colors.white, size: 20),
            ),
          ),

          // Form section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Pilih Poli"),
                  const SizedBox(height: 8),
                  _buildPoliDropdown(),
                  const SizedBox(height: 24),
                  
                  _buildLabel("Pilih Dokter"),
                  const SizedBox(height: 8),
                  _buildDokterDropdown(),
                  const SizedBox(height: 24),

                  _buildLabel("Pilih Jadwal"),
                  const SizedBox(height: 8),
                  _buildDatePicker(context),
                  const SizedBox(height: 32),

                  // Button Konfirmasi
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6EFD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DataPasienScreen(
                              selectedPoli: _selectedPoli,
                              selectedDate: _selectedDate != null 
                                ? "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}"
                                : null,
                              namaRS: widget.namaRS,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Konfirmasi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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



  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFFAFAFA), // Sangat light grey seperti mockup
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon,
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
        borderSide: const BorderSide(color: Color(0xFF0D6EFD), width: 1.5),
      ),
    );
  }

  Widget _buildPoliDropdown() {
    return DropdownButtonFormField<String>(
      decoration: _inputDecoration("-Pilih-"),
      value: _selectedPoli,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      isExpanded: true,
      items: RumahSakitData.poliList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedPoli = newValue;
        });
      },
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12), // Border radius untuk dropdown menu
    );
  }

  Widget _buildDokterDropdown() {
    return DropdownButtonFormField<String>(
      decoration: _inputDecoration("-Pilih-"),
      value: _selectedDokter,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      isExpanded: true,
      items: RumahSakitData.dokterList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedDokter = newValue;
        });
      },
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TextFormField(
      readOnly: true,
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      decoration: _inputDecoration(
        _selectedDate == null 
            ? "-Pilih-" 
            : "${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}",
        suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 20),
      ),
    );
  }
}
