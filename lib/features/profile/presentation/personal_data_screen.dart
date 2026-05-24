import 'package:flutter/material.dart';
import 'package:majadigi/core/widgets/custom_wave_header.dart';
import 'package:majadigi/features/profile/presentation/profile_dialogs.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({Key? key}) : super(key: key);

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomWaveHeader(title: 'Data Diri'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
            _buildTextField("Nama Lengkap", nameController, false),
            const SizedBox(height: 16),
            _buildTextField("NIK", nikController, false),
            const SizedBox(height: 16),
            _buildTextField("Email", emailController, false),
            const SizedBox(height: 16),
            _buildTextField("No HP", phoneController, false),
            const SizedBox(height: 16),
            
            // Row for Jenis Kelamin & Tanggal Lahir
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Jenis Kelamin', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        decoration: _inputDecoration(),
                        items: ['Laki - Laki', 'Perempuan'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField("Tanggal Lahir", TextEditingController(), false, readOnly: true),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildTextField("Alamat", addressController, true),
            
            const SizedBox(height: 40),
            
            // Simpan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D6EFD),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showSuccessPopup(context, "Data diri berhasil\ntersimpan!");
                },
                child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isMultiline, {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: isMultiline ? 3 : 1,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
      ),
    );
  }
}
