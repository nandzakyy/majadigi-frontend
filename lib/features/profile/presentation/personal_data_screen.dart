import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majadigi/core/widgets/custom_wave_header.dart';
import 'package:majadigi/features/profile/presentation/profile_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';

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
  final TextEditingController birthDateController = TextEditingController(); // DD/MM/YYYY
  
  String? selectedGender;

  final FocusNode _nikFocusNode = FocusNode();
  String? _nikErrorText;

  @override
  void initState() {
    super.initState();
    _nikFocusNode.addListener(_onNikFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final user = auth.currentUser;

      nameController.text = user?.fullName ?? auth.userFullName ?? '';
      nikController.text = user?.nik ?? '';
      emailController.text = auth.userEmail;
      phoneController.text = user?.phone ?? auth.userPhone;
      addressController.text = user?.address ?? '';

      if (user?.gender != null) {
        selectedGender = user!.gender == 'P' ? 'Perempuan' : 'Laki - Laki';
      }

      final birth = user?.birthDate;
      if (birth != null) {
        final dd = birth.day.toString().padLeft(2, '0');
        final mm = birth.month.toString().padLeft(2, '0');
        birthDateController.text = '$dd/$mm/${birth.year}';
      }
      setState(() {});
    });
  }

  void _onNikFocusChange() {
    if (!_nikFocusNode.hasFocus) {
      final nik = nikController.text.trim();
      if (nik.isNotEmpty && nik.length != 16) {
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
    nameController.dispose();
    nikController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    birthDateController.dispose();
    _nikFocusNode.removeListener(_onNikFocusChange);
    _nikFocusNode.dispose();
    super.dispose();
  }

  String? _genderToApi(String? gender) {
    if (gender == null) return null;
    final g = gender.toLowerCase();
    if (g.contains('laki')) return 'L';
    if (g.contains('perempuan')) return 'P';
    return null;
  }

  String? _birthDateToIso(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    final parts = trimmed.split('/');
    if (parts.length != 3) return null;
    final dd = int.tryParse(parts[0]);
    final mm = int.tryParse(parts[1]);
    final yyyy = int.tryParse(parts[2]);
    if (dd == null || mm == null || yyyy == null) return null;
    final mmStr = mm.toString().padLeft(2, '0');
    final ddStr = dd.toString().padLeft(2, '0');
    return '$yyyy-$mmStr-$ddStr';
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
    );
    if (picked == null) return;
    final dd = picked.day.toString().padLeft(2, '0');
    final mm = picked.month.toString().padLeft(2, '0');
    birthDateController.text = '$dd/$mm/${picked.year}';
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
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
            _buildTextField(
              "NIK",
              nikController,
              false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
              focusNode: _nikFocusNode,
              errorText: _nikErrorText,
            ),
            const SizedBox(height: 16),
            _buildTextField("Email", emailController, false, readOnly: true),
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
                        isExpanded: true,
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
                  child: GestureDetector(
                    onTap: _pickBirthDate,
                    child: AbsorbPointer(
                      child: _buildTextField("Tanggal Lahir", birthDateController, false, readOnly: true),
                    ),
                  ),
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
                  if (auth.isLoading) return;

                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();
                  final address = addressController.text.trim();
                  final nik = nikController.text.trim();
                  final genderApi = _genderToApi(selectedGender);
                  final birthIso = _birthDateToIso(birthDateController.text);

                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama lengkap tidak boleh kosong')));
                    return;
                  }
                  if (phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No HP tidak boleh kosong')));
                    return;
                  }
                  if (nik.isNotEmpty) {
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
                  }
                  setState(() {
                    _nikErrorText = null;
                  });
                  if (genderApi == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih jenis kelamin')));
                    return;
                  }
                  if (birthIso == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tanggal lahir tidak valid')));
                    return;
                  }

                  final first = name.split(' ').first;
                  final last = name.split(' ').skip(1).join(' ');

                  auth
                      .updateProfile(
                        firstName: first,
                        lastName: last,
                        fullName: name,
                        phone: phone,
                        address: address.isEmpty ? null : address,
                        nik: nik.isEmpty ? null : nik,
                        gender: genderApi,
                        birthDate: birthIso,
                      )
                      .then((success) {
                    if (!mounted) return;
                    if (success) {
                      showSuccessPopup(context, "Data diri berhasil\ntersimpan!");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(auth.errorMessage.isNotEmpty ? auth.errorMessage : 'Gagal menyimpan data')),
                      );
                    }
                  });
                },
                child: auth.isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isMultiline, {
    bool readOnly = false,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    String? errorText,
  }) {
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
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          decoration: _inputDecoration(errorText: errorText),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? errorText}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      errorText: errorText,
      errorStyle: const TextStyle(color: Colors.red),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
