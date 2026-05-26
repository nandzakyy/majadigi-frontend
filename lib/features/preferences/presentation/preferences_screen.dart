import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi/features/home/presentation/dynamic_loader_provider.dart';
class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String? _selectedRegion = "Surabaya";
  final List<String> _regions = ["Surabaya", "Malang", "Sidoarjo", "Blitar", "Kediri"];

  // Daftar kategori dan opsi di dalamnya
  final Map<String, List<String>> _serviceCategories = {
    'Layanan RSUD': [
      'Rawat Jalan/Poliklinik',
      'Rawat Inap',
      'IGD',
      'Penunjang Medik',
      'Laboratorium & Radiologi'
    ],
    'Transportasi': [
      'Transjatim'
    ],
    'Bantuan Sosial': [
      'Nomor Darurat',
      'Sapa Bansos'
    ],
    'Informasi Daerah': [
      'Destinasi Wisata',
      'Islamic Center'
    ],
  };

  // Set untuk menyimpan layanan yang dipilih (biar gampang nyari data unik)
  final Set<String> _selectedServices = {};

  @override
  Widget build(BuildContext context) {
    // Tombol aktif jika minimal 1 layanan dipilih
    bool isButtonEnabled = _selectedServices.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0D6EFD), // Warna biru vibrant Jatim
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Jarak sedikit di header sebelum sisi putih
          const SizedBox(height: 10),
          
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(top: 30, bottom: 20),
                        children: [
                          const Text(
                            'Pilih darimana asal daerahmu?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Dropdown Daerah
                          DropdownButtonFormField<String>(
                            value: _selectedRegion,
                            decoration: InputDecoration(
                              labelText: 'Pilih Daerah',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            items: _regions.map((region) {
                              return DropdownMenuItem(
                                value: region,
                                child: Text(region),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedRegion = val;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          const Text(
                            'Silahkan memilih kategori layanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Render semua kategori dan layanan
                          ..._serviceCategories.entries.map((entry) {
                            String categoryName = entry.key;
                            List<String> services = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categoryName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: services.map((serviceName) {
                                      bool isSelected = _selectedServices.contains(serviceName);
                                      return InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              _selectedServices.remove(serviceName);
                                            } else {
                                              _selectedServices.add(serviceName);
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: isSelected ? const Color(0xFF8BB5F8) : Colors.white,
                                            border: Border.all(
                                              color: isSelected ? const Color(0xFF8BB5F8) : Colors.grey.shade400,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            serviceName,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isSelected ? Colors.blue.shade800 : Colors.black87,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    
                    // Tombol Simpan
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 30, top: 10),
                      child: ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () {
                                // Eksekusi logika simpan profil disini
                                context.read<DynamicLoaderProvider>().saveUserPreferences(
                                  'user-123', // Dummy user ID
                                  _selectedRegion ?? "Surabaya",
                                  _selectedServices.toList(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tersimpan: ${_selectedServices.length} preferensi'),
                                  ),
                                );
                                Navigator.pop(context); // Kembali ke dashboard/login
                              }
                            : null, // Kalau null, tombol otomatis jadi abu-abu (disabled)
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B71F3),
                          disabledBackgroundColor: Colors.grey.shade200,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Simpan Preferensi Layanan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isButtonEnabled ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
