import 'package:flutter/material.dart';
import '../data/sidita_data.dart';
import '../models/wisata_model.dart';
import 'widgets/animated_pin_widget.dart';
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
  WisataModel? selectedPinWisata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "SIDITA",
            onSavePressed: () {},
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Image Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/wisata_bromo.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // TABS
                  Center(
                    child: SingleChildScrollView(
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
                  ),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              isExpanded: true,
                              hint: const Text("Jawa Timur (Pilih Lokasi)"),
                              value: selectedLocation,
                              icon: const Icon(Icons.filter_list),
                              items: [
                                const DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text("Jawa Timur (Pilih Lokasi)"),
                                ),
                                ...["Trenggalek", "Kediri", "Malang"].map((String value) {
                                  return DropdownMenuItem<String?>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  selectedLocation = val;
                                  selectedPinWisata = null; // Reset selected pin on region change
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Section Title if a region is selected
                        if (selectedLocation != null && selectedTabIndex == 0) ...[
                          Row(
                            children: const [
                              Text(
                                "Silahkan Pilih Top 3 Wisata di Bawah",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.location_on, color: Colors.red, size: 20),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],

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

  String _getMapAssetPath() {
    switch (selectedLocation) {
      case "Trenggalek":
        return 'assets/images/map_trenggalek.png';
      case "Kediri":
        return 'assets/images/map_kediri.png';
      case "Malang":
        return 'assets/images/map_malang.png';
      default:
        return 'assets/images/map_jawa_timur.png';
    }
  }

  double _getMapAspectRatio() {
    switch (selectedLocation) {
      case "Trenggalek":
        return 357 / 334;
      case "Kediri":
        return 354 / 294;
      case "Malang":
        return 353 / 240;
      default:
        return 347 / 290;
    }
  }

  List<WisataModel> _getCurrentWisataList() {
    if (selectedLocation == null) return [];
    return SiditaData.wisataList
        .where((w) => w.wilayah.toLowerCase() == selectedLocation!.toLowerCase())
        .toList();
  }

  Widget _petaTab() {
    final mapPath = _getMapAssetPath();
    final aspectRatio = _getMapAspectRatio();
    final wisataForRegion = _getCurrentWisataList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Background Map Image
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          mapPath,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    
                    // Pin Points
                    ...wisataForRegion.map((wisata) {
                      final double left = constraints.maxWidth * wisata.pinPosition.dx;
                      final double top = constraints.maxHeight * wisata.pinPosition.dy;
                      
                      // Subtract icon alignment (since icon size is 28)
                      const double pinIconWidth = 28.0;
                      const double pinIconHeight = 28.0;
                      
                      return Positioned(
                        left: left - (pinIconWidth / 2),
                        top: top - pinIconHeight,
                        child: AnimatedPinWidget(
                          wisata: wisata,
                          isActive: selectedPinWisata == wisata,
                          onTap: () {
                            setState(() {
                              selectedPinWisata = wisata;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ),
        if (selectedLocation != null) ...[
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0.0, 0.15),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ));
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
            child: selectedPinWisata == null
                ? Container(
                    key: const ValueKey('helper_text'),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    alignment: Alignment.center,
                    child: Text(
                      "Silahkan pilih salah satu pin wisata di bawah",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(
                    key: ValueKey(selectedPinWisata!.namaWisata),
                    child: _buildDetailCard(selectedPinWisata!),
                  ),
          ),
        ],
      ],
    );
  }

  Widget _daftarTab() {
    if (selectedLocation == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
          child: Text(
            "Silahkan pilih lokasi Jawa Timur terlebih dahulu di atas.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final paidWisataList = SiditaData.wisataList
        .where((w) => w.isPaid && w.wilayah.toLowerCase() == selectedLocation!.toLowerCase())
        .toList();

    if (paidWisataList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "Tidak ada wisata berbayar di wilayah ini.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: paidWisataList.map((wisata) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildWisataCard(wisata),
        );
      }).toList(),
    );
  }

  Widget _buildWisataCard(WisataModel wisata) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CheckoutScreen(wisata: wisata)),
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
                image: DecorationImage(
                  image: AssetImage(wisata.image),
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
                      Expanded(
                        child: Text(
                          wisata.namaWisata,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.bookmark, color: Colors.grey, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    wisata.alamat,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Text(
                              wisata.rating.toString(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
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

  Widget _buildDetailCard(WisataModel wisata) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
            child: Image.asset(
              wisata.image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wisata.namaWisata,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Wisata Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Wisata",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: wisata.isPaid ? Colors.red : Colors.green,
                                ),
                              ),
                              const SizedBox(width: 6),
                               Text(
                                wisata.status,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Vertical Divider
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 16),
                    // Jam Operasional
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Jam Operasional",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_outlined,
                                size: 16,
                                color: Colors.black87,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                wisata.jamOperasional,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Deskripsi",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  wisata.deskripsi,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


