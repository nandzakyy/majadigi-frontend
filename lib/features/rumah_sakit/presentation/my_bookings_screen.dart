import 'package:flutter/material.dart';
import 'package:majadigi/features/rumah_sakit/data/hospital_api.dart';
import 'package:provider/provider.dart';
import 'package:majadigi/features/auth/presentation/auth_provider.dart';
import 'package:majadigi/features/auth/presentation/login_screen.dart';
import 'package:majadigi/core/widgets/custom_wave_header.dart';

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
    final title = widget.hospitalName?.trim().isNotEmpty == true 
        ? widget.hospitalName!.trim() 
        : 'Riwayat Booking';
    final auth = Provider.of<AuthProvider>(context);
    
    if (!auth.isLoggedIn) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            CustomWaveHeader(title: title),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Silakan login untuk melihat riwayat booking.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D6EFD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          CustomWaveHeader(title: title),
          Expanded(
            child: RefreshIndicator(
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'Gagal memuat booking: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
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
                        const Center(
                          child: Text(
                            'Belum ada booking.',
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        ),
                        if ((filterName ?? '').isNotEmpty && items.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 24, right: 24),
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
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final b = filtered[index];
                      final time = '${b.startTime} - ${b.endTime}';
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
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
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.local_hospital_rounded,
                                    color: Color(0xFF0D6EFD),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (widget.hospitalName == null || widget.hospitalName!.trim().isEmpty)
                                        Text(
                                          b.hospitalName,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      Text(
                                        b.polyclinicName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${b.doctorName}${b.doctorTitle == null || b.doctorTitle!.isEmpty ? '' : ' (${b.doctorTitle})'}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFDBEAFE)),
                                  ),
                                  child: Text(
                                    '#${b.queueNumber}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D4ED8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(color: Color(0xFFF1F5F9), height: 1),
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
                                const SizedBox(width: 6),
                                Text(
                                  '${b.dayOfWeek} • ${_formatDate(b.scheduleDate)}',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade500),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    time,
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Pasien: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      Text(
                                        b.patientName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'NIK: ${b.patientNik}  •  Lahir: ${_formatDate(b.patientBirthDate)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
