import 'package:flutter/material.dart';
import 'checkout_screen.dart';
import 'ticket_list_screen.dart';
import '../../../core/widgets/custom_wave_header.dart';

class SiditaDestinasiScreen extends StatefulWidget {
  const SiditaDestinasiScreen({super.key});

  @override
  State<SiditaDestinasiScreen> createState() => _SiditaDestinasiScreenState();
}

class _SiditaDestinasiScreenState extends State<SiditaDestinasiScreen> {
  int selectedTabIndex = 0; // 0 for Peta, 1 for Daftar
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "SIDITA",
            rightWidget: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bookmark_border, color: Colors.white, size: 20),
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Banner
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/wisata_bromo.png'),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // TABS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _tab("Peta", 0),
                        const SizedBox(width: 8),
                        _tab("Daftar", 1),
                        const SizedBox(width: 8),
                        _tab("Tiket Saya", 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text("Jawa Timur (Pilih Lokasi)"),
                              value: selectedLocation,
                              icon: const Icon(Icons.filter_list),
                              items: ["Trenggalek", "Tulungagung", "Kediri", "Surabaya"].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedLocation = val;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        if (selectedTabIndex == 0) _petaTab(),
                        if (selectedTabIndex == 1) _daftarTab(),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String title, int index) {
    final active = index == selectedTabIndex;
    return GestureDetector(
      onTap: () {
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TicketListScreen()),
          );
          return;
        }
        setState(() => selectedTabIndex = index);
      },
      child: Container(
        width: 110,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFD3E4FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? const Color(0xFF0065FF) : Colors.grey.shade600,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _petaTab() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text("Peta Placeholder", style: TextStyle(color: Colors.grey)),
              ),
            ),
            const Positioned(top: 50, left: 80, child: Icon(Icons.location_on, color: Colors.red)),
            const Positioned(top: 100, left: 150, child: Icon(Icons.location_on, color: Colors.red)),
            const Positioned(top: 150, left: 100, child: Icon(Icons.location_on, color: Colors.red)),
            const Positioned(top: 80, right: 60, child: Icon(Icons.location_on, color: Colors.red)),
          ],
        ),
      ],
    );
  }

  Widget _daftarTab() {
    return Column(
      children: [
        // Button "Berdasarkan Lokasi Saya"
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F2FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Color(0xFF0065FF), size: 20),
              SizedBox(width: 8),
              Text(
                "Berdasarkan Lokasi Saya",
                style: TextStyle(color: Color(0xFF0065FF), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        _buildWisataCard("Hapuna Beach"),
        const SizedBox(height: 16),
        _buildWisataCard("Makena Beach"),
      ],
    );
  }

  Widget _buildWisataCard(String name) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CheckoutScreen(wisataName: name)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/wisata_beach.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Icon(Icons.bookmark, color: Colors.grey, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Jl. Lorem Ipsum Dolor Sit Amet Bandung No. 123",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text("4.1 km", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            const Text("7.8", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 2),
                            Icon(Icons.star, color: Colors.orange.shade400, size: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}


