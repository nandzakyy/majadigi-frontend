import 'package:flutter/material.dart';
import 'data_pasien_screen.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../data/hospital_api.dart';

class AntreanScreen extends StatefulWidget {
  final String namaRS;
  final int? hospitalId;
  const AntreanScreen({super.key, required this.namaRS, this.hospitalId});

  @override
  State<AntreanScreen> createState() => _AntreanScreenState();
}

class _AntreanScreenState extends State<AntreanScreen> {
  String? _selectedPoli;
  String? _selectedDokter;
  int? _selectedPolyclinicId;
  int? _selectedDoctorId;
  String? _selectedDay;
  DoctorSchedule? _selectedSchedule;

  List<Polyclinic> _polyclinics = const [];
  List<Doctor> _doctors = const [];
  List<DoctorSchedule> _schedules = const [];
  List<String> _availableDays = const [];
  bool _loadingPoli = false;
  bool _loadingDoctor = false;
  String _error = '';

  static const Map<int, String> _weekdayToId = {
    DateTime.monday: 'Senin',
    DateTime.tuesday: 'Selasa',
    DateTime.wednesday: 'Rabu',
    DateTime.thursday: 'Kamis',
    DateTime.friday: 'Jumat',
    DateTime.saturday: 'Sabtu',
    DateTime.sunday: 'Minggu',
  };

  @override
  void initState() {
    super.initState();
    if (widget.hospitalId != null) {
      _loadPolyclinics();
    }
  }

  Future<void> _loadPolyclinics() async {
    setState(() {
      _loadingPoli = true;
      _error = '';
    });
    try {
      final data = await HospitalApi().getPolyclinics(widget.hospitalId!);
      setState(() {
        _polyclinics = data;
        _loadingPoli = false;
      });
    } catch (e) {
      setState(() {
        _error = '$e';
        _loadingPoli = false;
      });
    }
  }

  Future<void> _loadDoctors(int polyclinicId) async {
    setState(() {
      _loadingDoctor = true;
      _error = '';
      _doctors = const [];
      _schedules = const [];
      _selectedDoctorId = null;
      _selectedDokter = null;
    });
    try {
      final data = await HospitalApi().getDoctors(polyclinicId);
      setState(() {
        _doctors = data;
        _loadingDoctor = false;
      });
    } catch (e) {
      setState(() {
        _error = '$e';
        _loadingDoctor = false;
      });
    }
  }

  Future<void> _loadSchedules(int doctorId) async {
    setState(() {
      _error = '';
      _schedules = const [];
      _availableDays = const [];
      _selectedDay = null;
      _selectedSchedule = null;
    });
    try {
      final data = await HospitalApi().getSchedules(doctorId);
      setState(() {
        _schedules = data;
        _availableDays = _buildAvailableDays(data);
      });
    } catch (e) {
      setState(() {
        _error = '$e';
      });
    }
  }

  List<String> _buildAvailableDays(List<DoctorSchedule> schedules) {
    const order = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final set = schedules.map((e) => e.dayOfWeek).where((e) => e.trim().isNotEmpty).toSet();
    return order.where(set.contains).toList();
  }

  String _nextDateIsoForDay(String dayName) {
    final dayNameToWeekday = <String, int>{
      'Senin': DateTime.monday,
      'Selasa': DateTime.tuesday,
      'Rabu': DateTime.wednesday,
      'Kamis': DateTime.thursday,
      'Jumat': DateTime.friday,
      'Sabtu': DateTime.saturday,
      'Minggu': DateTime.sunday,
    };
    final target = dayNameToWeekday[dayName] ?? DateTime.monday;
    var cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
    while (cursor.weekday != target) {
      cursor = cursor.add(const Duration(days: 1));
    }
    final dd = cursor.day.toString().padLeft(2, '0');
    final mm = cursor.month.toString().padLeft(2, '0');
    final yyyy = cursor.year.toString().padLeft(4, '0');
    return '$yyyy-$mm-$dd';
  }

  String _nextDateLabelFromIso(String iso) {
    if (iso.length < 10) return iso;
    final yyyy = iso.substring(0, 4);
    final mm = iso.substring(5, 7);
    final dd = iso.substring(8, 10);
    return '$dd/$mm/$yyyy';
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header biru melengkung
          CustomWaveHeader(
            title: "Informasi Antrean Pasien",
            onSavePressed: () {},
          ),

          // Form section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Pilih Poli"),
                  const SizedBox(height: 8),
                  _buildPoliDropdown(),
                  const SizedBox(height: 24),
                  
                  _buildLabel("Pilih Dokter"),
                  const SizedBox(height: 8),
                  _buildDokterDropdown(),
                  const SizedBox(height: 24),

                  _buildLabel("Pilih Jadwal"),
                  const SizedBox(height: 8),
                  _buildScheduleDropdown(),
                  const SizedBox(height: 32),

                  // Button Konfirmasi
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6EFD),
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: (_selectedPoli != null && _selectedDokter != null && _selectedSchedule != null)
                          ? () {
                              final scheduleId = _selectedSchedule!.id;
                              final scheduleDateIso = _nextDateIsoForDay(_selectedSchedule!.dayOfWeek);
                              final dateLabel = _nextDateLabelFromIso(scheduleDateIso);
                              final display = '$dateLabel (${_selectedSchedule!.dayOfWeek}) ${_selectedSchedule!.startTime} - ${_selectedSchedule!.endTime}';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: const RouteSettings(name: '/rs-patient'),
                                  builder: (context) => DataPasienScreen(
                                    selectedPoli: _selectedPoli,
                                    selectedDate: display,
                                    namaRS: widget.namaRS,
                                    scheduleId: scheduleId,
                                    scheduleDateIso: scheduleDateIso,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: const Text(
                        "Konfirmasi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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



  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFFAFAFA), // Sangat light grey seperti mockup
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0D6EFD), width: 1.5),
      ),
    );
  }

  Widget _buildPoliDropdown() {
    if (widget.hospitalId != null && _loadingPoli) {
      return const LinearProgressIndicator();
    }
    if (_error.isNotEmpty) {
      return Text(_error, style: TextStyle(color: Colors.red.shade700));
    }

    final items = widget.hospitalId != null
        ? _polyclinics.map((p) => DropdownMenuItem<String>(value: p.name, child: Text(p.name, style: const TextStyle(fontSize: 14)))).toList()
        : const <DropdownMenuItem<String>>[
            DropdownMenuItem(value: 'Poli Umum', child: Text('Poli Umum', style: TextStyle(fontSize: 14))),
            DropdownMenuItem(value: 'Poli Anak', child: Text('Poli Anak', style: TextStyle(fontSize: 14))),
            DropdownMenuItem(value: 'Poli Kandungan', child: Text('Poli Kandungan', style: TextStyle(fontSize: 14))),
          ];

    return DropdownButtonFormField<String>(
      decoration: _inputDecoration("-Pilih-"),
      value: _selectedPoli,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      isExpanded: true,
      items: items,
      onChanged: (newValue) {
        setState(() {
          _selectedPoli = newValue;
          if (widget.hospitalId != null) {
            final selected = _polyclinics.where((p) => p.name == newValue).toList();
            _selectedPolyclinicId = selected.isNotEmpty ? selected.first.id : null;
            if (_selectedPolyclinicId != null) {
              _loadDoctors(_selectedPolyclinicId!);
            }
          }
        });
      },
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12), // Border radius untuk dropdown menu
    );
  }

  Widget _buildDokterDropdown() {
    if (widget.hospitalId != null && _loadingDoctor) {
      return const LinearProgressIndicator();
    }
    if (_error.isNotEmpty) {
      return Text(_error, style: TextStyle(color: Colors.red.shade700));
    }

    final items = widget.hospitalId != null
        ? _doctors
            .map((d) => DropdownMenuItem<String>(value: d.name, child: Text(d.name, style: const TextStyle(fontSize: 14))))
            .toList()
        : const <DropdownMenuItem<String>>[
            DropdownMenuItem(value: 'dr. Umum', child: Text('dr. Umum', style: TextStyle(fontSize: 14))),
            DropdownMenuItem(value: 'dr. Spesialis', child: Text('dr. Spesialis', style: TextStyle(fontSize: 14))),
          ];

    return DropdownButtonFormField<String>(
      decoration: _inputDecoration("-Pilih-"),
      value: _selectedDokter,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      isExpanded: true,
      items: items,
      onChanged: (newValue) {
        setState(() {
          _selectedDokter = newValue;
          if (widget.hospitalId != null) {
            final selected = _doctors.where((d) => d.name == newValue).toList();
            _selectedDoctorId = selected.isNotEmpty ? selected.first.id : null;
            if (_selectedDoctorId != null) {
              _loadSchedules(_selectedDoctorId!);
            }
          }
        });
      },
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildScheduleDropdown() {
    if (_error.isNotEmpty) {
      return Text(_error, style: TextStyle(color: Colors.red.shade700));
    }
    if (widget.hospitalId != null && _selectedDoctorId != null && _schedules.isEmpty) {
      return const Text('Jadwal tidak tersedia', style: TextStyle(color: Colors.black54));
    }

    final schedulesForDay = _selectedDay == null
        ? const <DoctorSchedule>[]
        : _schedules.where((s) => s.dayOfWeek == _selectedDay).toList();

    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: _inputDecoration("Pilih Hari"),
          value: _selectedDay,
          isExpanded: true,
          items: _availableDays
              .map((d) => DropdownMenuItem<String>(
                    value: d,
                    child: Text(d, style: const TextStyle(fontSize: 14)),
                  ))
              .toList(),
          onChanged: (day) {
            setState(() {
              _selectedDay = day;
              _selectedSchedule = null;
            });
          },
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<DoctorSchedule>(
          decoration: _inputDecoration("Pilih Jam"),
          value: _selectedSchedule,
          isExpanded: true,
          items: schedulesForDay
              .map((s) => DropdownMenuItem<DoctorSchedule>(
                    value: s,
                    child: Text('${s.startTime} - ${s.endTime}', style: const TextStyle(fontSize: 14)),
                  ))
              .toList(),
          onChanged: schedulesForDay.isEmpty
              ? null
              : (schedule) {
                  setState(() {
                    _selectedSchedule = schedule;
                  });
                },
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        if (_selectedSchedule != null) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tanggal terdekat: ${_nextDateLabelFromIso(_nextDateIsoForDay(_selectedSchedule!.dayOfWeek))}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        ],
      ],
    );
  }
}
