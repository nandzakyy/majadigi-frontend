import 'package:flutter/material.dart';

class AntreanScreen extends StatefulWidget {
  const AntreanScreen({super.key});

  @override
  State<AntreanScreen> createState() => _AntreanScreenState();
}

class _AntreanScreenState extends State<AntreanScreen> {
  String? _selectedPoli;
  String? _selectedDokter;
  DateTime? _selectedDate;

  final List<String> _poliList = [
    "IGD",
    "KLINIK MATA",
    "KLINIK PENYAKIT DALAM",
    "KLINIK KULIT KELAMIN",
    "KLINIK BEDAH",
    "KLINIK JANTUNG",
    "KLINIK KUSTA",
    "KLINIK KEBIDANAN & KANDUNGAN"
  ];

  final List<String> _dokterList = [
    "Dr. Andi",
    "Dr. Budi",
    "Dr. Citra"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header biru melengkung
          _buildHeader(context),

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
                        // Aksi konfirmasi
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Konfirmasi berhasil')),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0D6EFD),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Text(
                "Informasi Antrean Pasien",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bookmark_add_outlined,
                color: Colors.white, size: 20),
          )
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
      items: _poliList.map((String value) {
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
      items: _dokterList.map((String value) {
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
