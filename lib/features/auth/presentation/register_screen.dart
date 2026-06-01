import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:majadigi/features/auth/presentation/login_screen.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';
import 'package:majadigi/features/home/presentation/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 1;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _selectedGender;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  final _addressController = TextEditingController();
  final _nikController = TextEditingController();
  final _regionController = TextEditingController();
  final _birthDateController = TextEditingController(); // DD/MM/YYYY (UI), converted to YYYY-MM-DD (API)
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    _nikController.dispose();
    _regionController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
    String label,
    String hint, {
    required TextEditingController controller,
    Key? fieldKey,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onToggle,
    bool readOnly = false,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        TextField(
          key: fieldKey,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? !isVisible : false,
          readOnly: readOnly,
          onTap: onTap,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: onToggle,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  bool _isValidEmail(String email) {
    final v = email.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
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
    if (yyyy < 1900 || yyyy > 2100) return null;
    if (mm < 1 || mm > 12) return null;
    if (dd < 1 || dd > 31) return null;
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
    _birthDateController.text = '$dd/$mm/${picked.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D6EFD), // Warna biru vibrant
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_currentStep == 2) {
                            setState(() => _currentStep = 1);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.language, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Bahasa Indonesia',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Daftar Akun',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Buat akun dan nikmati semua fitur layanan publik\ndalam satu aplikasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            
            // Bottom Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      Center(
                        child: Image.asset(
                          'assets/images/majadigi_logo.png',
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Toggle Masuk / Daftar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Center(
                                    child: Text(
                                      'Masuk',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                ),
                                child: const Center(
                                  child: Text(
                                    'Daftar',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Step Indicator
                      RichText(
                        text: TextSpan(
                          text: 'Langkah $_currentStep/',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                          children: const [
                            TextSpan(
                              text: '2',
                              style: TextStyle(color: Color(0xFF0D6EFD)),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Fields Flow
                      if (_currentStep == 1) ...[
                        _buildTextField(
                          'Nama Depan',
                          'Masukkan nama depan',
                          controller: _firstNameController,
                          fieldKey: const ValueKey('reg_first_name'),
                        ),
                        _buildTextField(
                          'Nama Belakang',
                          'Masukkan nama belakang',
                          controller: _lastNameController,
                          fieldKey: const ValueKey('reg_last_name'),
                        ),
                        _buildTextField(
                          'No HP',
                          'Masukkan nomor HP',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          fieldKey: const ValueKey('reg_phone'),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12),
                          ],
                        ),
                        _buildTextField(
                          'Email',
                          'Masukkan email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          fieldKey: const ValueKey('reg_email'),
                        ),
                        _buildTextField(
                          'Username',
                          'Buat username (unik)',
                          controller: _usernameController,
                          fieldKey: const ValueKey('reg_username'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            final firstName = _firstNameController.text.trim();
                            final lastName = _lastNameController.text.trim();
                            final phone = _phoneController.text.trim();
                            final email = _emailController.text.trim();
                            final username = _usernameController.text.trim();

                            if (firstName.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama depan tidak boleh kosong')));
                              return;
                            }
                            if (lastName.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama belakang tidak boleh kosong')));
                              return;
                            }
                            if (phone.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No HP tidak boleh kosong')));
                              return;
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor HP hanya boleh berisi angka')));
                              return;
                            }
                            if (!phone.startsWith('08')) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor HP harus diawali dengan "08"')));
                              return;
                            }
                            if (phone.length < 9 || phone.length > 12) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor HP harus memiliki panjang 9-12 digit')));
                              return;
                            }
                            if (email.isEmpty || !_isValidEmail(email)) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email tidak valid')));
                              return;
                            }
                            if (username.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username tidak boleh kosong')));
                              return;
                            }

                            setState(() => _currentStep = 2);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B71F3),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Selanjutnya', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ] else ...[
                        _buildTextField(
                          'Alamat',
                          'Masukkan alamat lengkap',
                          controller: _addressController,
                          keyboardType: TextInputType.streetAddress,
                          fieldKey: const ValueKey('reg_address'),
                        ),
                        _buildTextField(
                          'NIK (Opsional)',
                          '16 digit',
                          controller: _nikController,
                          keyboardType: TextInputType.number,
                          fieldKey: const ValueKey('reg_nik'),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                          ],
                        ),
                        _buildTextField(
                          'Region (Opsional)',
                          'Contoh: Malang',
                          controller: _regionController,
                          fieldKey: const ValueKey('reg_region'),
                        ),
                        _buildTextField(
                          'Tanggal Lahir',
                          'Pilih Tanggal Lahir',
                          controller: _birthDateController,
                          readOnly: true,
                          onTap: _pickBirthDate,
                          fieldKey: const ValueKey('reg_birth_date'),
                        ),
                        
                        // Dropdown Jenis Kelamin
                        const Text(
                          'Jenis Kelamin',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          isExpanded: true,
                          hint: const Text(
                            'Pilih Jenis Kelamin',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Laki - Laki',
                              child: Text(
                                'Laki - Laki',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Perempuan',
                              child: Text(
                                'Perempuan',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _selectedGender = val;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          'Password',
                          '********',
                          controller: _passwordController,
                          fieldKey: const ValueKey('reg_password'),
                          isPassword: true,
                          isVisible: _isPasswordVisible,
                          onToggle: () {
                            setState(() => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                        _buildTextField(
                          'Ulangi Password',
                          '********',
                          controller: _confirmPasswordController,
                          fieldKey: const ValueKey('reg_confirm_password'),
                          isPassword: true,
                          isVisible: _isConfirmPasswordVisible,
                          onToggle: () {
                            setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                          },
                        ),
                        
                        const SizedBox(height: 8),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (authProvider.errorMessage.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      border: Border.all(color: Colors.red.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      authProvider.errorMessage,
                                      style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                                    ),
                                  ),
                                ElevatedButton(
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : () async {
                                          final firstName = _firstNameController.text.trim();
                                          final lastName = _lastNameController.text.trim();
                                          final phone = _phoneController.text.trim();
                                          final email = _emailController.text.trim();
                                          final username = _usernameController.text.trim();
                                          final address = _addressController.text.trim();
                                          final nik = _nikController.text.trim();
                                          final region = _regionController.text.trim();
                                          final birthIso = _birthDateToIso(_birthDateController.text);
                                          final genderApi = _genderToApi(_selectedGender);
                                          final password = _passwordController.text;
                                          final confirm = _confirmPasswordController.text;

                                          if (address.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alamat tidak boleh kosong')));
                                            return;
                                          }
                                          if (username.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username tidak boleh kosong')));
                                            return;
                                          }
                                          if (nik.isNotEmpty) {
                                            if (!RegExp(r'^[0-9]+$').hasMatch(nik)) {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('NIK harus berupa angka saja')));
                                              return;
                                            }
                                            if (nik.length != 16) {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('NIK harus tepat 16 digit')));
                                              return;
                                            }
                                          }
                                          if (birthIso == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tanggal lahir tidak valid (DD/MM/YYYY)')));
                                            return;
                                          }
                                          if (genderApi == null) {
                                            return;
                                          }
                                          if (password.trim().isEmpty || password.length < 6) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password minimal 6 karakter')));
                                            return;
                                          }
                                          if (password != confirm) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ulangi password tidak sama')));
                                            return;
                                          }

                                          final fullName = '$firstName $lastName'.trim();

                                          final success = await authProvider.registerUser(
                                            email: email,
                                            username: username,
                                            password: password,
                                            firstName: firstName,
                                            lastName: lastName,
                                            fullName: fullName,
                                            phone: phone,
                                            nik: nik.isEmpty ? null : nik,
                                            region: region.isEmpty ? null : region,
                                            address: address,
                                            gender: genderApi,
                                            birthDate: birthIso,
                                          );

                                          if (!mounted) return;
                                          if (success) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Registrasi berhasil!'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                                              (_) => false,
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3B71F3),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: authProvider.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Daftar', style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
