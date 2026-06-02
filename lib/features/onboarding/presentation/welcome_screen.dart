import 'package:flutter/material.dart';
import 'package:majadigi/features/auth/presentation/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Wave transition animation (from State 1 to State 3)
  late Animation<double> _waveAnimation;

  // Text position transition animation (from State 1 to State 3)
  late Animation<double> _textAnimation;

  // Logo fade and scale animation (State 3)
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Total duration extended to 2600ms for a smoother, premium feel
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    // Wave and text slide up: 20% to 70% of duration (520ms to 1820ms)
    // Using Curves.easeOutBack to rise up and settle slightly back down
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.70, curve: Curves.easeOutBack),
      ),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.70, curve: Curves.easeOutBack),
      ),
    );

    // Logo fade in: 70% to 95% of duration (1820ms to 2470ms)
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 0.95, curve: Curves.easeIn),
      ),
    );

    // Logo scale in (gentle zoom in/scale effect): 70% to 95%
    _logoScaleAnimation = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 0.95, curve: Curves.easeOut),
      ),
    );

    // Start the animation immediately
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Helper to interpolate double values
          double lerp(double start, double end, double t) => start + (end - start) * t;

          // Dark Blue Wave (Background layer) - Sinks slightly down to open space
          final double dbStart = lerp(screenHeight * 0.60, screenHeight * 0.64, _waveAnimation.value);
          final double dbControl = lerp(screenHeight * 0.72, screenHeight * 0.76, _waveAnimation.value);
          final double dbEnd = dbStart; // Symmetrical circular curve

          // Light Blue Wave (Top layer) - Rises up significantly (lowered to screenHeight * 0.32)
          final double lbStart = lerp(screenHeight * 0.58, screenHeight * 0.32, _waveAnimation.value);
          final double lbControl = lerp(screenHeight * 0.70, screenHeight * 0.44, _waveAnimation.value);
          final double lbEnd = lbStart; // Symmetrical circular curve

          // Text vertical translation (lowered to screenHeight * 0.15)
          final double textTop = lerp(screenHeight * 0.38, screenHeight * 0.15, _textAnimation.value);

          // Static button position based on final dbControl to avoid moving
          final double staticDbControl = screenHeight * 0.76;
          final double buttonTop = staticDbControl + (screenHeight - staticDbControl) / 2 - 26;

          // Entire view zooms out gently during transition (from 1.08 scale to 1.0)
          final double overallScale = lerp(1.08, 1.0, _waveAnimation.value);

          return Transform.scale(
            scale: overallScale,
            child: Stack(
              children: [
                // 1. Dark Blue Wave (Background layer)
                ClipPath(
                  clipper: WaveClipper(
                    startHeight: dbStart,
                    controlHeight: dbControl,
                    endHeight: dbEnd,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xFF084298),
                  ),
                ),

                // 2. Light Blue Wave (Top layer)
                ClipPath(
                  clipper: WaveClipper(
                    startHeight: lbStart,
                    controlHeight: lbControl,
                    endHeight: lbEnd,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xFF0D6EFD),
                  ),
                ),

                // 3. Greeting and Subtitle text (Animated vertical position)
                Positioned(
                  top: textTop,
                  left: 24,
                  right: 24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Selamat Datang di Majadigi!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Platform layanan publik Jawa Timur.\nSimple. Cerdas. terhubung sepenuhnya',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. Logo (MAJADIGI card logo copy.png, fades/scales in after waves settle)
                Positioned(
                  top: screenHeight * 0.45,
                  left: 24,
                  right: 24,
                  child: FadeTransition(
                    opacity: _logoOpacityAnimation,
                    child: ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: Center(
                        child: Image.asset(
                          'assets/images/majadigi_logo copy.png',
                          height: 90,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Gambar logo tidak ditemukan',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // 5. "Lanjut" Button at the bottom of white area
                Positioned(
                  top: buttonTop,
                  left: 24,
                  right: 24,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Reset the controller and wait for push
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                        // Replay the animation from the start when popped back to the splash screen
                        _controller.reset();
                        _controller.forward();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B71F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Lanjut',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double startHeight;
  final double controlHeight;
  final double endHeight;

  WaveClipper({
    required this.startHeight,
    required this.controlHeight,
    required this.endHeight,
  });

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, startHeight);
    // Center control point (size.width / 2) for perfect symmetrical round curve
    path.quadraticBezierTo(
      size.width / 2, controlHeight,
      size.width, endHeight
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant WaveClipper oldClipper) {
    return oldClipper.startHeight != startHeight ||
        oldClipper.controlHeight != controlHeight ||
        oldClipper.endHeight != endHeight;
  }
}
