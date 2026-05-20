import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/custom_wave_header.dart';

class DataPasienScreen extends StatelessWidget {
  final String? selectedPoli;
  final String? selectedDate;
  final String namaRS;

  const DataPasienScreen({
    super.key,
    this.selectedPoli,
    this.selectedDate,
    required this.namaRS,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header konsisten dengan AntreanScreen
          CustomWaveHeader(
            title: "Data Pasien",
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
                  // Section "Pasien"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pasien",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Isi data pasien",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: Colors.red.shade400,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildLabel("NIK"),
                  const SizedBox(height: 8),
                  _buildTextField("Masukkan NIK"),
                  const SizedBox(height: 24),
                  
                  _buildLabel("Nama"),
                  const SizedBox(height: 8),
                  _buildTextField("Masukkan Nama Lengkap"),
                  const SizedBox(height: 24),

                  _buildLabel("Tanggal Lahir"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    "dd/mm/yyyy", 
                    icon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: [DateInputFormatter()],
                  ),
                  const SizedBox(height: 32),

                  // Button Ambil Antrean
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
                        if (selectedPoli == null || selectedDate == null || selectedPoli!.isEmpty || selectedDate!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Harap lengkapi data terlebih dahulu')),
                          );
                          return;
                        }
                        _showAntreanDialog(context);
                      },
                      child: const Text(
                        "Ambil Antrean",
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

  Widget _buildTextField(String hintText, {IconData? icon, List<TextInputFormatter>? inputFormatters, TextInputType? keyboardType}) {
    return TextField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: icon != null ? Icon(icon, color: Colors.grey, size: 20) : null,
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
      ),
    );
  }

  void _showAntreanDialog(BuildContext context) {
    // Generate nomor antrean random (contoh B-004)
    final String noAntrean = "B-${(DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0')}";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ticket Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      namaRS,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "NOMOR ANTREAN",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _dashedDivider(),
                    const SizedBox(height: 16),
                    Text(
                      noAntrean,
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _dashedDivider(),
                    const SizedBox(height: 24),
                    Text(
                      selectedPoli ?? "-",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedDate ?? "-",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Harap datang sebelum nomor\ndipanggil",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                children: [
                  // Download Button
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D6EFD),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.file_download_outlined, color: Colors.white),
                      onPressed: () {
                        // Optional action for download
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Selesai Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D6EFD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showSuccessSnackbar(context);
                        },
                        child: const Text(
                          "Selesai",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dashedDivider() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
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
        backgroundColor: const Color(0xFFF4F8FF), // Sangat light blue
        elevation: 0,
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5EFFF)), // Border halus
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
                    "Nomor Antrean Berhasil di Unduh.",
                    style: TextStyle(
                      color: Color(0xFF0D6EFD),
                      fontSize: 14,
                    ),
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

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (text.length > 8) {
      return oldValue; 
    }

    var newText = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) {
        newText += '/';
      }
      newText += text[i];
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
