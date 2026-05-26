import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../data/hospital_api.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../auth/presentation/login_screen.dart';

class KamarScreen extends StatefulWidget {
  final int hospitalId;
  final String? hospitalName;

  const KamarScreen({super.key, required this.hospitalId, this.hospitalName});

  @override
  State<KamarScreen> createState() => _KamarScreenState();
}

class _KamarScreenState extends State<KamarScreen> {
  int? _effectiveHospitalId;
  late Future<RoomAvailabilityResponse> _future;

  @override
  void initState() {
    super.initState();
    _effectiveHospitalId = widget.hospitalId;
    _future = HospitalApi().getRooms(_effectiveHospitalId!);
    _resolveHospitalIdIfNeeded();
  }

  String _norm(String input) => input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');

  Future<void> _resolveHospitalIdIfNeeded() async {
    final name = widget.hospitalName?.trim();
    if (name == null || name.isEmpty) return;

    try {
      final hospitals = await HospitalApi().getHospitals();
      final target = _norm(name);
      final match = hospitals.where((h) => _norm(h.name).contains(target) || target.contains(_norm(h.name))).toList();
      if (match.isEmpty) return;
      final resolvedId = match.first.id;
      if (resolvedId == _effectiveHospitalId) return;
      setState(() {
        _effectiveHospitalId = resolvedId;
        _future = HospitalApi().getRooms(_effectiveHospitalId!);
      });
    } catch (_) {
      // ignore: keep given hospitalId
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 42, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('Silakan login untuk melihat ketersediaan kamar.', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "Ketersediaan Kamar Rawat",
            onSavePressed: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ketersediaan Kamar Rawat",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<RoomAvailabilityResponse>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('Gagal memuat ringkasan: ${snapshot.error}', style: TextStyle(color: Colors.red.shade700));
                      }

                      final data = snapshot.data ?? RoomAvailabilityResponse(summary: RoomAvailabilitySummary(total: 0, available: 0), details: const []);
                      final total = data.summary.total;
                      final available = data.summary.available;
                      final occupied = (total - available) < 0 ? 0 : (total - available);

                      return Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            child: Row(
                              children: [
                                _buildStatCard(
                                  value: "$total",
                                  label: "Total Kamar Rawat",
                                  valueColor: Colors.black87,
                                  icon: Icons.domain,
                                  iconColor: Colors.grey.shade700,
                                  iconBgColor: Colors.grey.shade100,
                                ),
                                _buildStatCard(
                                  value: "$available",
                                  label: "Tersedia",
                                  valueColor: Colors.green,
                                  icon: Icons.how_to_reg,
                                  iconColor: Colors.green,
                                  iconBgColor: Colors.green.shade50,
                                ),
                                _buildStatCard(
                                  value: "$occupied",
                                  label: "Terisi",
                                  valueColor: Colors.orange,
                                  icon: Icons.groups,
                                  iconColor: Colors.orange,
                                  iconBgColor: Colors.orange.shade50,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Status Ketersediaan Ruangan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRuanganList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildStatCard({
    required String value,
    required String label,
    required Color valueColor,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      width: 210, // Diperlebar agar tampak memanjang
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  maxLines: 1, // Memaksa agar tetap 1 baris
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildRuanganList() {
    return FutureBuilder<RoomAvailabilityResponse>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Text('Gagal memuat data kamar: ${snapshot.error}', style: TextStyle(color: Colors.red.shade700));
        }

        final response = snapshot.data ?? RoomAvailabilityResponse(summary: RoomAvailabilitySummary(total: 0, available: 0), details: const []);
        final details = response.details;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Header Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Ruang",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: const Text(
                        "Kapasitas",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: const Text(
                        "Terisi",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: const Text(
                        "Tersedia",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.transparent),
              if (details.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Tidak ada data ruangan.'),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: details.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = details[index];
                    final total = item.totalBeds;
                    final available = item.availableBeds;
                    final occupied = (total - available) < 0 ? 0 : (total - available);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${item.roomName} (${item.roomClass})',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              '$total',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Text(
                              '$occupied',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              '$available',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
