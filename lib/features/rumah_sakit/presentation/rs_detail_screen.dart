import 'package:flutter/material.dart';
import 'antrean_screen.dart';
import 'kamar_screen.dart';
import '../data/rumah_sakit_data.dart';
import '../data/hospital_api.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../../../core/widgets/custom_accordion_widget.dart';
import '../../../core/widgets/custom_tab_selector.dart';
import '../../../core/widgets/custom_info_card.dart';
import 'my_bookings_screen.dart';
import 'package:provider/provider.dart';
import '../../auth/presentation/auth_provider.dart';

class RSDetailScreen extends StatelessWidget {
  final int? hospitalId;

  final String nama;
  final String alamat;
  final String deskripsi;
  final String linkLayanan;
  final String jamOperasional;
  final String logoPath;

  const RSDetailScreen({
    super.key,
    this.hospitalId,
    required this.nama,
    required this.alamat,
    required this.logoPath,
    this.deskripsi =
        "Rumah Sakit rujukan layanan kesehatan berstatus A di Jawa Timur",
    this.linkLayanan = "https://rsudrsoetomo.jatimprov.go.id/",
    this.jamOperasional = "Senin - Minggu: 24 Jam",
  });

  @override
  Widget build(BuildContext context) {
    Future<int?> resolveHospitalId() async {
      if (hospitalId != null) return hospitalId;
      final norm = (String s) => s.toLowerCase().replaceAll('.', '').replaceAll(RegExp(r'\\bdr\\b'), '').replaceAll(RegExp(r'\\brsud\\b'), '').replaceAll(RegExp(r'[^a-z0-9]+'), '');
      try {
        final hospitals = await HospitalApi().getHospitals();
        final target = norm(nama);
        final match = hospitals.where((h) => norm(h.name).contains(target) || target.contains(norm(h.name))).toList();
        return match.isNotEmpty ? match.first.id : null;
      } catch (_) {
        return null;
      }
    }

    return FutureBuilder<int?>(
      future: resolveHospitalId(),
      builder: (context, idSnap) {
        if (idSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final resolvedId = idSnap.data;
        if (resolvedId == null) {
          // fall back to static details (limited)
          int selectedTabIndex = 0;

          final data = RumahSakitData.rsDetailData[nama] ?? {};
          final activeDeskripsi = data["deskripsi"] ?? deskripsi;
          final activeLink = _getHospitalUrl(nama, data["link"] ?? linkLayanan);
          final activeAlamat = data["alamat"] ?? alamat;
          final activeJam = data["jam"] ?? jamOperasional;

	          return _buildScaffold(
	            context,
	            selectedTabIndexInitial: selectedTabIndex,
	            hospitalId: null,
	            resolvedHospitalName: nama,
	            activeDeskripsi: activeDeskripsi,
	            activeLink: activeLink,
	            activeAlamat: activeAlamat,
	            activeJam: activeJam,
	          );
	        }

        return FutureBuilder<Hospital?>(
          future: HospitalApi().getHospital(resolvedId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final hospital = snapshot.data;
            final activeDeskripsi = hospital?.description ?? deskripsi;
            final activeLink = _getHospitalUrl(nama, hospital?.websiteUrl ?? linkLayanan);
            final activeAlamat = hospital?.address ?? alamat;
            final activeJam = jamOperasional;
            final resolvedHospitalName = hospital?.name?.trim().isNotEmpty == true ? hospital!.name : nama;
            return _buildScaffold(
              context,
              selectedTabIndexInitial: 0,
              hospitalId: resolvedId,
              resolvedHospitalName: resolvedHospitalName,
              activeDeskripsi: activeDeskripsi,
              activeLink: activeLink,
              activeAlamat: activeAlamat,
              activeJam: activeJam,
            );
          },
        );
      },
    );

  }

  Widget _buildScaffold(
    BuildContext context, {
    required int selectedTabIndexInitial,
    required int? hospitalId,
    required String resolvedHospitalName,
    required String activeDeskripsi,
    required String activeLink,
    required String activeAlamat,
    required String activeJam,
  }) {
    int selectedTabIndex = selectedTabIndexInitial;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: nama,
            onSavePressed: () {},
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  _buildLogo(logoPath),
                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nama,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              activeDeskripsi,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // TAB
                            CustomTabSelector(
                              tabs: const ["Layanan", "Operasional", "Ketentuan Umum"],
                              selectedIndex: selectedTabIndex,
                              onChanged: (index) {
                                setState(() {
                                  selectedTabIndex = index;
                                });
                              },
                            ),

                            const SizedBox(height: 24),

                            if (selectedTabIndex == 0) _layananTab(context, hospitalId: hospitalId, resolvedHospitalName: resolvedHospitalName),
                            if (selectedTabIndex == 1) _operasionalTab(activeLink, activeAlamat, activeJam),
                            if (selectedTabIndex == 2) _ketentuanTab(hospitalId: hospitalId),

                            const SizedBox(height: 32),
                          ],
                        );
                      },
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



  // ================= LOGO =================
  Widget _buildLogo(String logoPath) {
    return Image.asset(
      logoPath,
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }



  // ================= TAB: LAYANAN =================
  Widget _layananTab(BuildContext context, {required int? hospitalId, required String resolvedHospitalName}) {
    return Column(
      children: [
        CustomInfoCard(
          icon: Icons.people,
          title: "Informasi Antrean Pasien",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: '/rs-queue'),
                builder: (_) => AntreanScreen(namaRS: nama, hospitalId: hospitalId),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          icon: Icons.bed,
          title: "Ketersediaan Kamar Rawat",
          onTap: () {
            if (hospitalId == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data rumah sakit belum tersedia.')));
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: (_) => KamarScreen(hospitalId: hospitalId!, hospitalName: resolvedHospitalName)));
          },
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          icon: Icons.receipt_long,
          title: "Riwayat Booking Saya",
          onTap: () {
            final auth = Provider.of<AuthProvider>(context, listen: false);
            if (!auth.isLoggedIn) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan login untuk melihat riwayat booking.')));
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: (_) => MyBookingsScreen(hospitalName: resolvedHospitalName)));
          },
        ),
      ],
    );
  }

  // ================= TAB: OPERASIONAL =================
  Widget _operasionalTab(String activeLink, String activeAlamat, String activeJam) {
    return Column(
      children: [
        CustomInfoCard(
          title: "Link Layanan",
          subtitle: activeLink,
          isLink: true,
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          title: "Alamat",
          subtitle: activeAlamat,
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          title: "Jam Operasional",
          subtitle: activeJam,
        ),
      ],
    );
  }

  // ================= TAB: KETENTUAN =================
  Widget _ketentuanTab({required int? hospitalId}) {
    if (hospitalId == null) {
      final data = RumahSakitData.ketentuanData;
      return Column(
        children: data.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CustomAccordionWidget(
              title: item["title"]!,
              content: item["content"]!,
            ),
          );
        }).toList(),
      );
    }

    final Future<List<List<String>>> combinedFuture = Future.wait([
      HospitalApi().getOperationalInfo(hospitalId, category: 'requirement'),
      HospitalApi().getOperationalInfo(hospitalId, category: 'benefit'),
    ]);

    return FutureBuilder<List<List<String>>>(
      future: combinedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final results = snapshot.data ?? const [[], []];
        final requirements = results[0];
        final benefits = results[1];

        return Column(
          children: [
            if (benefits.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomAccordionWidget(
                  title: 'Manfaat',
                  content: benefits.join('\n'),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomAccordionWidget(
                title: 'Ketentuan Umum',
                content: requirements.isNotEmpty
                    ? requirements.join('\n')
                    : 'Silakan membawa identitas resmi dan mengikuti alur pendaftaran sesuai ketentuan rumah sakit.',
              ),
            ),
          ],
        );
      },
    );
  }

  String _getHospitalUrl(String name, String fallbackLink) {
    final cleanName = name.toLowerCase();
    if (cleanName.contains('soetomo')) {
      return 'https://rsudrsoetomo.jatimprov.go.id/';
    } else if (cleanName.contains('daha husada')) {
      return 'https://rsuddahahusada.jatimprov.go.id/';
    } else if (cleanName.contains('haji')) {
      return 'https://app.rsuhaji.jatimprov.go.id/online/';
    } else if (cleanName.contains('saiful anwar')) {
      return 'https://rsusaifulanwar.jatimprov.go.id/v2/';
    } else if (cleanName.contains('karsa husada')) {
      return 'https://rsukarsahusadabatu.jatimprov.go.id/';
    }
    return fallbackLink;
  }
}


