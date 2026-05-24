import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomWaveHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final Widget? rightWidget;
  final VoidCallback? onSavePressed;
  final VoidCallback? onBackTap;

  const CustomWaveHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.rightWidget,
    this.onSavePressed,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = topPadding + kToolbarHeight + (subtitle != null ? 56 : 40);

    return Container(
      height: headerHeight,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Color(0xFF0065FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: _HeaderWaveClipper(),
              child: Container(color: const Color(0xFF005FF0)),
            ),
          ),
          Positioned(
            top: topPadding + 16,
            left: 16,
            right: 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (showBackButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: onBackTap ?? () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/vectors/back_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                if (rightWidget != null || onSavePressed != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: rightWidget ??
                        GestureDetector(
                          onTap: onSavePressed,
                          child: SvgPicture.asset(
                            'assets/vectors/save_icon.svg',
                            width: 40,
                            height: 40,
                          ),
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.70);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.95,
      size.width * 0.5,
      size.height * 0.70,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.45,
      size.width,
      size.height * 0.65,
    );

    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
