import 'package:flutter/material.dart';
import 'package:majadigi/core/widgets/custom_wave_header.dart';
import 'package:majadigi/features/profile/presentation/profile_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomWaveHeader(title: 'Ubah Kata Sandi'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildPasswordField(
                    label: "Kata Sandi Lama",
                    controller: oldPassController,
                    hint: "Masukkan kata sandi lama",
                    obscure: _obscureOld,
                    onToggle: () {
                      setState(() {
                        _obscureOld = !_obscureOld;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    label: "Kata Sandi Baru",
                    controller: newPassController,
                    hint: "Masukkan kata sandi baru",
                    obscure: _obscureNew,
                    onToggle: () {
                      setState(() {
                        _obscureNew = !_obscureNew;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    label: "Konfirmasi Kata Sandi Baru",
                    controller: confirmPassController,
                    hint: "Konfirmasi kata sandi baru",
                    obscure: _obscureConfirm,
                    onToggle: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
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
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              final oldPass = oldPassController.text;
                              final newPass = newPassController.text;
                              final confirm = confirmPassController.text;

                              if (oldPass.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kata sandi lama wajib diisi')));
                                return;
                              }
                              if (newPass.trim().length < 6) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kata sandi baru minimal 6 karakter')));
                                return;
                              }
                              if (newPass != confirm) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konfirmasi kata sandi tidak sama')));
                                return;
                              }

                              final success = await auth.changePassword(oldPassword: oldPass, newPassword: newPass);
                              if (!mounted) return;

                              if (success) {
                                oldPassController.clear();
                                newPassController.clear();
                                confirmPassController.clear();
                                showSuccessPopup(context, "Kata sandi berhasil\ndiperbarui!");
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(auth.errorMessage.isNotEmpty ? auth.errorMessage : 'Gagal mengubah kata sandi')),
                                );
                              }
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            children: const [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: onToggle,
            ),
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
          ),
        ),
      ],
    );
  }
}
