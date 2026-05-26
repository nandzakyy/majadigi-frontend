import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomWaveHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final Widget? rightWidget;
  final Widget? leadingWidget;
  final bool centerTitle;
  final VoidCallback? onSavePressed;
  final VoidCallback? onBackTap;
  final Color bottomCurveColor;
  final bool useWaveStyle;

  const CustomWaveHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.rightWidget,
    this.leadingWidget,
    this.centerTitle = true,
    this.onSavePressed,
    this.onBackTap,
    this.bottomCurveColor = Colors.white,
    this.useWaveStyle = true,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    if (useWaveStyle) {
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
              top: topPadding + 12,
              left: 16,
              right: 16,
              child: centerTitle ? _buildCenteredTitle(context) : _buildLeftTitle(context),
            ),
          ],
        ),
      );
    } else {
      final headerHeight = topPadding + kToolbarHeight + (subtitle != null ? 64 : 44);
      return Container(
        height: headerHeight,
        color: const Color(0xFF0065FF),
        child: Stack(
          children: [
            Positioned(
              top: topPadding + 12,
              left: 16,
              right: 16,
              child: centerTitle ? _buildCenteredTitle(context) : _buildLeftTitle(context),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 32,
              child: Container(
                decoration: BoxDecoration(
                  color: bottomCurveColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCenteredTitle(BuildContext context) {
    return Stack(
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
    );
  }

  Widget _buildLeftTitle(BuildContext context) {
    return Row(
      children: [
        if (leadingWidget != null) ...[
          leadingWidget!,
          const SizedBox(width: 12),
        ] else if (showBackButton) ...[
          GestureDetector(
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
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (rightWidget != null || onSavePressed != null)
          rightWidget ??
              GestureDetector(
                onTap: onSavePressed,
                child: SvgPicture.asset(
                  'assets/vectors/save_icon.svg',
                  width: 40,
                  height: 40,
                ),
              ),
      ],
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

