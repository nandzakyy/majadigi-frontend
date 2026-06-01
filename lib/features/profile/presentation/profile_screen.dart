import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';
import 'package:majadigi/features/profile/presentation/personal_data_screen.dart';
import 'package:majadigi/features/profile/presentation/change_password_screen.dart';
import 'package:majadigi/features/profile/presentation/profile_dialogs.dart';
import 'package:majadigi/features/profile/presentation/about_jatim_screen.dart';

import 'package:majadigi/features/profile/presentation/about_majadigi_screen.dart';
import 'package:majadigi/features/profile/presentation/terms_screen.dart';
import 'package:majadigi/features/profile/presentation/privacy_screen.dart';
import 'package:majadigi/features/onboarding/presentation/welcome_screen.dart';
import 'package:majadigi/features/home/presentation/dynamic_loader_provider.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void>? _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = Provider.of<AuthProvider>(context, listen: false).fetchMe().then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<AuthProvider>(context, listen: false).fetchMe();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
            // Header Section
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Blue Wave Background
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: const Color(0xFF0D6EFD),
                  ),
                ),
                // Avatar
                Positioned(
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: Colors.orange.shade100,
                      // For now using icon as dummy avatar
                      child: const Icon(Icons.person, size: 50, color: Colors.orange),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // User Info
            FutureBuilder<void>(
              future: _loadFuture,
              builder: (context, snapshot) {
                final displayName = !auth.isLoggedIn
                    ? 'Pengunjung'
                    : ((auth.userFullName?.trim().isNotEmpty ?? false)
                        ? auth.userFullName!
                        : (auth.userName.isNotEmpty ? auth.userName : 'Pengguna'));

                return Column(
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    if (auth.errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          auth.errorMessage,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              '${auth.userEmail.isNotEmpty ? auth.userEmail : "Email Kosong"} | ${auth.userPhone.isNotEmpty ? auth.userPhone : "08xxxx"}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),

            // Menus
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Akun & Keamanan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildListTile(
                    icon: Icons.person_outline,
                    title: 'Data Diri',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PersonalDataScreen()),
                      );
                    },
                  ),
                  _buildListTile(
                    icon: Icons.lock_outline,
                    title: 'Ubah Kata Sandi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Informasi Lainnya',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildListTile(
                    icon: Icons.location_on_outlined,
                    title: 'Tentang Jawa Timur',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutJatimScreen()),
                      );
                    },
                  ),

                  _buildListTile(
                    icon: Icons.info_outline,
                    title: 'Tentang Majadigi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutMajadigiScreen()),
                      );
                    },
                  ),
                  _buildListTile(
                    icon: Icons.star_border,
                    title: 'Beri Rating',
                    trailingText: 'Versi 2.1.0',
                    onTap: () async {
                      final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=id.go.jatimprov.portal');
                      if (!await launchUrl(url)) {
                        debugPrint('Could not launch \$url');
                      }
                    },
                  ),
                  _buildListTile(
                    icon: Icons.menu_book_outlined,
                    title: 'Syarat dan Ketentuan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TermsScreen()),
                      );
                    },
                  ),
                  _buildListTile(
                    icon: Icons.shield_outlined,
                    title: 'Kebijakan Privasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  
                  // Keluar Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade100, width: 1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    onPressed: () {
                        showLogoutWarning(context, () {
                          Provider.of<AuthProvider>(context, listen: false).logout().then((_) {
                            Provider.of<DynamicLoaderProvider>(context, listen: false).enterGuestMode();
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                            (_) => false,
                          );
                        });
                      },
                      icon: const Icon(Icons.exit_to_app, color: Colors.red),
                      label: const Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 110 + MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w400),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          if (trailingText != null) const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }
}
