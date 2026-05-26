import 'package:flutter/material.dart';
import '../../models/wisata_model.dart';

class AnimatedPinWidget extends StatefulWidget {
  final WisataModel wisata;
  final bool isActive;
  final VoidCallback onTap;

  const AnimatedPinWidget({
    super.key,
    required this.wisata,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<AnimatedPinWidget> createState() => _AnimatedPinWidgetState();
}

class _AnimatedPinWidgetState extends State<AnimatedPinWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    // Smooth bounce or pulse animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic color based on active state
    final Color activeColor = const Color(0xFF0065FF); // Premium active blue
    final Color inactiveColor = const Color(0xFFD32F2F); // Red
    final Color pinColor = widget.isActive ? activeColor : inactiveColor;
    
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Combination of small bounce (y-offset) and pulse (scale)
          final double bounce = _animation.value * -6.0;
          final double scale = 1.0 + (_animation.value * 0.12);

          return Transform.translate(
            offset: Offset(0, bounce),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          );
        },
        child: SizedBox(
          width: 28,
          height: 28,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Marker Icon (centered in the 28x28 box)
              Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse halo ring under the pin
                  widget.isActive
                      ? Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeColor.withOpacity(0.3),
                          ),
                        )
                      : Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: inactiveColor.withOpacity(0.2),
                          ),
                        ),
                  Icon(
                    Icons.location_on,
                    color: pinColor,
                    size: 28,
                  ),
                ],
              ),
              
              // Positioned Label
              _buildPositionedLabel(pinColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPositionedLabel(Color pinColor) {
    final labelWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: pinColor.withOpacity(0.5),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        widget.wisata.namaWisata,
        style: TextStyle(
          color: pinColor,
          fontSize: 10,
          fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.visible,
      ),
    );

    switch (widget.wisata.pinTextDirection) {
      case PinTextDirection.left:
        return Positioned(
          right: 32, // 4px margin left of icon
          top: 0,
          bottom: 0,
          child: Center(
            child: labelWidget,
          ),
        );
      case PinTextDirection.leftBottom:
        return Positioned(
          right: 18, // shifted left
          top: 22,   // below icon
          child: labelWidget,
        );
      case PinTextDirection.right:
        return Positioned(
          left: 32, // 4px margin right of icon
          top: 0,
          bottom: 0,
          child: Center(
            child: labelWidget,
          ),
        );
    }
  }
}
