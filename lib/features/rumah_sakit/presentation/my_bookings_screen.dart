import 'package:flutter/material.dart';
import 'package:majadigi/features/rumah_sakit/data/hospital_api.dart';
import 'package:provider/provider.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';
import 'package:majadigi/features/auth/presentation/login_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  final String? hospitalName;
  const MyBookingsScreen({super.key, this.hospitalName});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final HospitalApi _api = HospitalApi();
  late Future<List<QueueBooking>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.getMyQueues();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _api.getMyQueues();
    });
    await _future;
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final dd = dt.day.toString().padLeft(2, '0');
      final mm = dt.month.toString().padLeft(2, '0');
      final yyyy = dt.year.toString().padLeft(4, '0');
      return '$dd/$mm/$yyyy';
    } catch (_) {
      return raw;
    }
  }

  String _norm(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.hospitalName?.trim().isNotEmpty == true ? widget.hospitalName!.trim() : 'Riwayat Booking';
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 42, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('Silakan login untuk melihat riwayat booking.', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<QueueBooking>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  Center(child: Text('Gagal memuat booking: ${snapshot.error}')),
                ],
              );
            }

            final items = snapshot.data ?? const [];
            final filterName = widget.hospitalName?.trim();
            final filtered = filterName == null || filterName.isEmpty
                ? items
                : items.where((b) => _norm(b.hospitalName).contains(_norm(filterName))).toList();
            if (filtered.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  const Center(child: Text('Belum ada booking.')),
                  if ((filterName ?? '').isNotEmpty && items.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Center(
                        child: Text(
                          'Catatan: Ada booking lain, tapi tidak cocok dengan filter rumah sakit.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final b = filtered[index];
                final time = '${b.startTime} - ${b.endTime}';
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F9FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.local_hospital, color: Color(0xFF0D6EFD)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.hospitalName == null || widget.hospitalName!.trim().isEmpty)
                                  Text(b.hospitalName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text(
                                  b.polyclinicName,
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${b.doctorName}${b.doctorTitle == null || b.doctorTitle!.isEmpty ? '' : ' (${b.doctorTitle})'}',
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          _pill('#${b.queueNumber}'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _pill('${b.dayOfWeek} • ${_formatDate(b.scheduleDate)}'),
                          const SizedBox(width: 8),
                          _pill(time),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Pasien: ${b.patientName}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'NIK: ${b.patientNik} • Lahir: ${_formatDate(b.patientBirthDate)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE6EEFf)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
