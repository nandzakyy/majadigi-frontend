import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';

class DaruratScreen extends StatelessWidget {
  const DaruratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWaveHeader(title: "Nomor Darurat"),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Polisi: 110\nAmbulans: 118\nPemadam: 113",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
