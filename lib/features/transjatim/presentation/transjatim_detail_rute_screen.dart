import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';

class TransJatimDetailRuteScreen extends StatefulWidget {
  final String from;
  final String to;

  const TransJatimDetailRuteScreen({
    Key? key,
    required this.from,
    required this.to,
  }) : super(key: key);

  @override
  State<TransJatimDetailRuteScreen> createState() => _TransJatimDetailRuteScreenState();
}

class _TransJatimDetailRuteScreenState extends State<TransJatimDetailRuteScreen> {
  late String currentFrom;
  late String currentTo;
  late String routeImageAsset;

  @override
  void initState() {
    super.initState();
    currentFrom = widget.from;
    currentTo = widget.to;
    routeImageAsset = _getRouteImage(currentFrom, currentTo);
  }

  String _getRouteImage(String from, String to) {
    final fromLower = from.toLowerCase();
    final toLower = to.toLowerCase();
    
    // 1. gresik - sidoarjo via surabaya
    if ((fromLower.contains('gresik') && toLower.contains('sidoarjo')) ||
        (fromLower.contains('sidoarjo') && toLower.contains('gresik'))) {
      if (fromLower.contains('mojokerto') || toLower.contains('mojokerto')) {
        return 'assets/images/sdrd_mjkrt.png';
      }
      return 'assets/images/grk_sdrj.png';
    }
    // 2. terminal bunder - terminal paciran
    if ((fromLower.contains('terminal bunder') && toLower.contains('terminal paciran')) ||
        (fromLower.contains('terminal paciran') && toLower.contains('terminal bunder'))) {
      return 'assets/images/tb_tp.png';
    }
    // 3. surabaya - bangkalan
    if ((fromLower.contains('surabaya') && toLower.contains('bangkalan')) ||
        (fromLower.contains('bangkalan') && toLower.contains('surabaya'))) {
      return 'assets/images/sby_bgkl.png';
    }
    // 4. sidoarjo - mojokerto
    if ((fromLower.contains('sidoarjo') && toLower.contains('mojokerto')) ||
        (fromLower.contains('mojokerto') && toLower.contains('sidoarjo'))) {
      return 'assets/images/sdrd_mjkrt.png';
    }
    // 5. terminal lamongan - terminal paciran
    if ((fromLower.contains('terminal lamongan') && toLower.contains('terminal paciran')) ||
        (fromLower.contains('terminal paciran') && toLower.contains('terminal lamongan'))) {
      return 'assets/images/tl_tp.png';
    }
    // 6. terminal hamid rusdi - terminal batu
    if ((fromLower.contains('terminal hamid rusdi') && toLower.contains('terminal batu')) ||
        (fromLower.contains('terminal batu') && toLower.contains('terminal hamid rusdi'))) {
      return 'assets/images/thr_tb.png';
    }
    // 7. surabaya - mojokerto
    if ((fromLower.contains('surabaya') && toLower.contains('mojokerto')) ||
        (fromLower.contains('mojokerto') && toLower.contains('surabaya'))) {
      return 'assets/images/sby_mjkrt.png';
    }
    // 8. mojokerto - gresik
    if ((fromLower.contains('mojokerto') && toLower.contains('gresik')) ||
        (fromLower.contains('gresik') && toLower.contains('mojokerto'))) {
      return 'assets/images/mjkrt_grk.png';
    }
    // 9. gresik - lamongan
    if ((fromLower.contains('gresik') && toLower.contains('lamongan')) ||
        (fromLower.contains('lamongan') && toLower.contains('gresik'))) {
      return 'assets/images/grk_lmg.png';
    }
    return 'assets/images/grk_sdrj.png';
  }

  void _swapLocations() {
    setState(() {
      String temp = currentFrom;
      currentFrom = currentTo;
      currentTo = temp;
      routeImageAsset = _getRouteImage(currentFrom, currentTo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomWaveHeader(
            title: 'Detail Rute',
          ),
          Expanded(
            child: Stack(
              children: [
                // Full-screen route map image
                Positioned.fill(
                  bottom: 200,
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 5.0,
                    child: Image.asset(
                      routeImageAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Bottom Card Section
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Column(
                              children: [
                                _buildLocationField('Dari', currentFrom),
                                const SizedBox(height: 20),
                                _buildLocationField('Ke', currentTo),
                              ],
                            ),
                            Positioned(
                              right: 24,
                              child: GestureDetector(
                                onTap: _swapLocations,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D6EFD), // Blue primary
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                        const BoxShadow(
                                          color: Color.fromRGBO(13, 110, 253, 0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.swap_vert,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
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



  Widget _buildLocationField(String label, String value) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 20, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C3E50),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
