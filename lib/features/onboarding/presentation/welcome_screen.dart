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

    // Total duration: 900ms delay + 600ms text slide + 500ms logo fade/scale = 2000ms
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Wave and text slide up: 900ms to 1500ms (0.45 to 0.75)
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.75, curve: Curves.easeInOut),
      ),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.75, curve: Curves.easeInOut),
      ),
    );

    // Logo fade in: 1500ms to 2000ms (0.75 to 1.0)
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    // Logo scale in: 1500ms to 2000ms (0.75 to 1.0)
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Start the animation immediately and play it once
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

          // Dark Blue Wave (Background layer) - Stays static
          final double dbStart = screenHeight * 0.62;
          final double dbControl = screenHeight * 0.72;
          final double dbEnd = screenHeight * 0.58;

          // Light Blue Wave (Top layer) - Moves up significantly
          final double lbStart = lerp(screenHeight * 0.60, screenHeight * 0.25, _waveAnimation.value);
          final double lbControl = lerp(screenHeight * 0.70, screenHeight * 0.33, _waveAnimation.value);
          final double lbEnd = lerp(screenHeight * 0.56, screenHeight * 0.20, _waveAnimation.value);

          // Text vertical translation
          final double textTop = lerp(screenHeight * 0.38, screenHeight * 0.08, _textAnimation.value);

          return Stack(
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
                  color: const Color(0xFF084298), // Dark Blue matching the designs
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
                  color: const Color(0xFF0D6EFD), // Light Blue vibrant color
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

              // 4. Logo (MAJADIGI card logo copy.png, fades/scales in State 3)
              Positioned(
                top: screenHeight * 0.38,
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
                top: dbControl + (screenHeight - dbControl) / 2 - 26,
                left: 24,
                right: 24,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
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
    path.quadraticBezierTo(
      size.width / 2.5, controlHeight,
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
