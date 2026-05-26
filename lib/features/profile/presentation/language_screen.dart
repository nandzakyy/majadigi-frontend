import 'package:flutter/material.dart';
import 'package:majadigi/core/widgets/custom_wave_header.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomWaveHeader(title: 'Bahasa'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                const Text(
                  'Disarankan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                ),
                const SizedBox(height: 16),
                _buildLanguageItem('English'),
                _buildLanguageItem('Indonesia'),
                
                const SizedBox(height: 32),
                const Text(
                  'Lainnya',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                ),
                const SizedBox(height: 16),
                _buildLanguageItem('Jawa'),
                _buildLanguageItem('Madura'),
                _buildLanguageItem('Osing'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(String language) {
    bool isSelected = _selectedLanguage == language;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0D6EFD) : Colors.blue.shade200,
                  width: isSelected ? 6 : 1.5,
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
