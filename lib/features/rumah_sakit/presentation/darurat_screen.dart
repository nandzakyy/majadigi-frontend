import 'package:flutter/material.dart';

class DaruratScreen extends StatelessWidget {
  const DaruratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nomor Darurat")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Polisi: 110\nAmbulans: 118\nPemadam: 113",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
