import 'package:flutter/material.dart';

class CustomWaveHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final Widget? rightWidget;

  const CustomWaveHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = topPadding + kToolbarHeight + 40;

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
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (rightWidget != null)
                  Align(alignment: Alignment.centerRight, child: rightWidget!)
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
