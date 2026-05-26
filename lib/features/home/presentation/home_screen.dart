import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:majadigi/core/theme/app_colors.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';
import 'package:majadigi/features/profile/presentation/profile_screen.dart';
import 'package:majadigi/features/home/presentation/dashboard_view.dart';
import 'package:majadigi/features/home/presentation/layanan_screen.dart';
import 'package:majadigi/features/onboarding/presentation/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardView(),
      LayananScreen(onBack: () {
        setState(() {
          _currentIndex = 0;
        });
      }),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isLoggedIn) {
      return const WelcomeScreen();
    }
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      margin: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: bottomPadding > 0 ? bottomPadding + 6 : 16,
        top: 8,
      ),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_outlined, Icons.home, 'Beranda'),
          _buildNavItem(1, Icons.wallet_outlined, Icons.wallet, 'Layanan'),
          _buildNavItem(2, Icons.person_outline, Icons.person, 'Akun'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData inactiveIcon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.primary : Colors.grey.shade400;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
