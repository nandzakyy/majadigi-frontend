import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:majadigi/features/auth/presentation/auth_provider.dart';
import 'package:majadigi/features/home/presentation/dynamic_loader_provider.dart';
import 'package:majadigi/features/home/presentation/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool showRegisterFirst;
  const LoginScreen({Key? key, this.showRegisterFirst = false}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _activeTab = 0; // 0 for login, 1 for register
  bool _isPasswordVisible = false;
  bool _rememberPassword = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Register state variables
  int _currentStep = 1;
  bool _isRegPasswordVisible = false;
  bool _isRegConfirmPasswordVisible = false;
  String? _selectedGender;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController(text: '08');
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  final _addressController = TextEditingController();
  final _nikController = TextEditingController();
  final _regionController = TextEditingController();
  final _birthDateController = TextEditingController(); // DD/MM/YYYY
  final _regPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FocusNode _nikFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  String? _nikErrorText;
  String? _emailErrorText;
  String? _phoneErrorText;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.showRegisterFirst ? 1 : 0;
    _nikFocusNode.addListener(_onNikFocusChange);
    _emailFocusNode.addListener(_onEmailFocusChange);
    _phoneFocusNode.addListener(_onPhoneFocusChange);
  }

  void _onNikFocusChange() {
    if (!_nikFocusNode.hasFocus) {
      final nik = _nikController.text.trim();
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

  void _onEmailFocusChange() {
    if (!_emailFocusNode.hasFocus) {
      final email = _emailController.text.trim();
      if (email.isEmpty) {
        setState(() {
          _emailErrorText = 'Email tidak boleh kosong';
        });
      } else if (!email.endsWith('@gmail.com')) {
        setState(() {
          _emailErrorText = 'Email harus diakhiri dengan @gmail.com';
        });
      } else {
        setState(() {
          _emailErrorText = null;
        });
      }
    }
  }

  void _onPhoneFocusChange() {
    if (!_phoneFocusNode.hasFocus) {
      final phone = _phoneController.text.trim();
      if (phone.isEmpty || phone == '08') {
        setState(() {
          _phoneErrorText = 'No HP tidak boleh kosong';
        });
      } else if (phone.length < 9 || phone.length > 12) {
        setState(() {
          _phoneErrorText = 'Nomor HP harus memiliki panjang 9-12 digit';
        });
      } else {
        setState(() {
          _phoneErrorText = null;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    _nikController.dispose();
    _regionController.dispose();
    _birthDateController.dispose();
    _regPasswordController.dispose();
    _confirmPasswordController.dispose();
    _nikFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
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
    FocusNode? focusNode,
    String? errorText,
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
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            errorStyle: const TextStyle(color: Colors.red),
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D6EFD),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Section (Blue Background)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                children: [
                  // App Bar Custom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_activeTab == 1 && _currentStep == 2) {
                            setState(() => _currentStep = 1);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    _activeTab == 0 ? 'Masuk' : 'Daftar Akun',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _activeTab == 0
                        ? 'Akses layanan publik di Jawa Timur lebih mudah\ndalam satu aplikasi.'
                        : 'Buat akun dan nikmati semua fitur layanan publik\ndalam satu aplikasi',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Bottom Section (White Form Area)
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
                      const SizedBox(height: 24),

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
                                  setState(() {
                                    _activeTab = 0;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: _activeTab == 0
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                        )
                                      : null,
                                  child: Center(
                                    child: Text(
                                      'Masuk',
                                      style: TextStyle(
                                        fontWeight: _activeTab == 0 ? FontWeight.bold : FontWeight.normal,
                                        color: _activeTab == 0 ? Colors.black87 : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _activeTab = 1;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: _activeTab == 1
                                      ? BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                        )
                                      : null,
                                  child: Center(
                                    child: Text(
                                      'Daftar',
                                      style: TextStyle(
                                        fontWeight: _activeTab == 1 ? FontWeight.bold : FontWeight.normal,
                                        color: _activeTab == 1 ? Colors.black87 : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Animated Switcher for smooth tab transition
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: _activeTab == 0
                            ? _buildLoginForm(context)
                            : _buildRegisterForm(context),
                      ),
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

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      key: const ValueKey('login_form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email Field
        const Text(
          'Email',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Masukkan email',
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

        // Password Field
        const Text(
          'Password',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: '********',
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
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

        // Ingat Password & Lupa Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _rememberPassword,
                    onChanged: (val) {
                      setState(() {
                        _rememberPassword = val ?? false;
                      });
                    },
                    activeColor: const Color(0xFF0D6EFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ingat Password',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Lupa Password ?',
                style: TextStyle(color: Color(0xFF0D6EFD), fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Auth API-driven login
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
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Email tidak boleh kosong')),
                            );
                            return;
                          }
                          if (password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password tidak boleh kosong')),
                            );
                            return;
                          }

                          final success = await authProvider.loginWithEmail(
                            email: email,
                            password: password,
                          );

                          if (mounted && success) {
                            final userKey = authProvider.userEmail.isNotEmpty ? authProvider.userEmail : authProvider.userName;
                            await Provider.of<DynamicLoaderProvider>(context, listen: false).syncFromBackendIfLoggedIn(userKey: userKey);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Login berhasil! Selamat datang ${authProvider.userName}'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
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
                      : const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // Divider ATAU
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Atau',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 24),

        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return OutlinedButton.icon(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      final success = await authProvider.loginWithGoogle();
                      if (!mounted) return;
                      if (success) {
                        final userKey = authProvider.userEmail.isNotEmpty ? authProvider.userEmail : authProvider.userName;
                        await Provider.of<DynamicLoaderProvider>(context, listen: false).syncFromBackendIfLoggedIn(userKey: userKey);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login Google berhasil! Selamat datang ${authProvider.userName}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
              icon: Image.asset(
                'assets/images/logo_google.png',
                width: 24,
                height: 24,
              ),
              label: const Text(
                'Masuk dengan Google',
                style: TextStyle(color: Colors.black87),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Column(
      key: const ValueKey('register_form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              PrefixTextInputFormatter('08'),
              LengthLimitingTextInputFormatter(12),
            ],
            focusNode: _phoneFocusNode,
            errorText: _phoneErrorText,
          ),
          _buildTextField(
            'Email',
            'Masukkan email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            fieldKey: const ValueKey('reg_email'),
            focusNode: _emailFocusNode,
            errorText: _emailErrorText,
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
              if (phone.isEmpty || phone == '08') {
                setState(() {
                  _phoneErrorText = 'No HP tidak boleh kosong';
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No HP tidak boleh kosong')));
                return;
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                setState(() {
                  _phoneErrorText = 'Nomor HP hanya boleh berisi angka';
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor HP hanya boleh berisi angka')));
                return;
              }
              if (!phone.startsWith('08')) {
                setState(() {
                  _phoneErrorText = 'Nomor HP harus diawali dengan "08"';
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor HP harus diawali dengan "08"')));
                return;
              }
              if (phone.length < 9 || phone.length > 12) {
                setState(() {
                  _phoneErrorText = 'Nomor HP harus memiliki panjang 9-12 digit';
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor HP harus memiliki panjang 9-12 digit')));
                return;
              }
              setState(() {
                _phoneErrorText = null;
              });

              if (email.isEmpty) {
                setState(() {
                  _emailErrorText = 'Email tidak boleh kosong';
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email tidak boleh kosong')));
                return;
              }
              if (!email.endsWith('@gmail.com')) {
                setState(() {
                  _emailErrorText = 'Email harus diakhiri dengan @gmail.com';
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email harus menggunakan domain @gmail.com')));
                return;
              }
              setState(() {
                _emailErrorText = null;
              });
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
            'Region (Opsional)',
            'Contoh: Malang',
            controller: _regionController,
            fieldKey: const ValueKey('reg_region'),
          ),
          _buildTextField(
            'NIK',
            '16 digit',
            controller: _nikController,
            keyboardType: TextInputType.number,
            fieldKey: const ValueKey('reg_nik'),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            focusNode: _nikFocusNode,
            errorText: _nikErrorText,
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
            controller: _regPasswordController,
            fieldKey: const ValueKey('reg_password'),
            isPassword: true,
            isVisible: _isRegPasswordVisible,
            onToggle: () {
              setState(() => _isRegPasswordVisible = !_isRegPasswordVisible);
            },
          ),
          _buildTextField(
            'Ulangi Password',
            '********',
            controller: _confirmPasswordController,
            fieldKey: const ValueKey('reg_confirm_password'),
            isPassword: true,
            isVisible: _isRegConfirmPasswordVisible,
            onToggle: () {
              setState(() => _isRegConfirmPasswordVisible = !_isRegConfirmPasswordVisible);
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
                            final password = _regPasswordController.text;
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
                            if (birthIso == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tanggal lahir tidak valid (DD/MM/YYYY)')));
                              return;
                            }
                            if (genderApi == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jenis kelamin belum dipilih')));
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
    );
  }
}

class PrefixTextInputFormatter extends TextInputFormatter {
  final String prefix;

  PrefixTextInputFormatter(this.prefix);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.text.startsWith(prefix)) {
      if (newValue.text.isEmpty || newValue.text.length < prefix.length) {
        return TextEditingValue(
          text: prefix,
          selection: TextSelection.collapsed(offset: prefix.length),
        );
      }
      return oldValue;
    }
    return newValue;
  }
}
