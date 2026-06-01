import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/custom_wave_header.dart';
import '../../../core/utils/file_download/file_download.dart';
import '../data/hospital_api.dart';

class DataPasienScreen extends StatefulWidget {
  final String? selectedPoli;
  final String? selectedDate;
  final String namaRS;
  final int? scheduleId;
  final String? scheduleDateIso; // YYYY-MM-DD

  const DataPasienScreen({
    super.key,
    this.selectedPoli,
    this.selectedDate,
    required this.namaRS,
    this.scheduleId,
    this.scheduleDateIso,
  });

  @override
  State<DataPasienScreen> createState() => _DataPasienScreenState();
}

class _DataPasienScreenState extends State<DataPasienScreen> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();

  bool _submitting = false;

  final FocusNode _nikFocusNode = FocusNode();
  String? _nikErrorText;

  bool get _isFormValid {
    return _nikController.text.trim().isNotEmpty &&
        _namaController.text.trim().isNotEmpty &&
        _tglLahirController.text.trim().length == 10;
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _nikController.addListener(_updateState);
    _namaController.addListener(_updateState);
    _tglLahirController.addListener(_updateState);
    _nikFocusNode.addListener(_onNikFocusChange);
  }

  void _onNikFocusChange() {
    if (!_nikFocusNode.hasFocus) {
      final nik = _nikController.text.trim();
      if (nik.isEmpty) {
        setState(() {
          _nikErrorText = 'NIK tidak boleh kosong';
        });
      } else if (nik.length != 16) {
        setState(() {
          _nikErrorText = 'NIK harus tepat 16 digit';
        });
      } else {
        setState(() {
          _nikErrorText = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _tglLahirController.dispose();
    _nikFocusNode.removeListener(_onNikFocusChange);
    _nikFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(title: "Data Pasien", onSavePressed: () {}),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pasien",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Isi data pasien",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: Colors.red.shade400,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildLabel("NIK"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _nikController,
                    "Masukkan NIK",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                    focusNode: _nikFocusNode,
                    errorText: _nikErrorText,
                  ),

                  const SizedBox(height: 24),

                  _buildLabel("Nama"),
                  const SizedBox(height: 8),
                  _buildTextField(_namaController, "Masukkan Nama Lengkap"),

                  const SizedBox(height: 24),

                  _buildLabel("Tanggal Lahir"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    _tglLahirController,
                    "dd/mm/yyyy",
                    icon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    onTap: () async {
                      final now = DateTime.now();

                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(
                          now.year - 20,
                          now.month,
                          now.day,
                        ),
                        firstDate: DateTime(1900, 1, 1),
                        lastDate: now,
                      );

                      if (picked == null) return;

                      final dd = picked.day.toString().padLeft(2, '0');
                      final mm = picked.month.toString().padLeft(2, '0');
                      final yyyy = picked.year.toString().padLeft(4, '0');

                      _tglLahirController.text = '$dd/$mm/$yyyy';
                    },
                  ),

                  const SizedBox(height: 32),

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
                      onPressed: (_isFormValid && !_submitting)
                          ? () async {
                              final nik = _nikController.text.trim();
                              if (!RegExp(r'^[0-9]+$').hasMatch(nik)) {
                                setState(() {
                                  _nikErrorText = 'NIK harus berupa angka saja';
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('NIK harus berupa angka saja'),
                                  ),
                                );
                                return;
                              }
                              if (nik.length != 16) {
                                setState(() {
                                  _nikErrorText = 'NIK harus tepat 16 digit';
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('NIK harus tepat 16 digit'),
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                _nikErrorText = null;
                              });

                              if (widget.selectedPoli == null ||
                                  widget.selectedDate == null ||
                                  widget.selectedPoli!.isEmpty ||
                                  widget.selectedDate!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Harap lengkapi data terlebih dahulu',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (widget.scheduleId != null &&
                                  widget.scheduleDateIso != null) {
                                await _submitQueueAndShowDialog(context);
                                return;
                              }

                              _showAntreanDialog(context);
                            }
                          : null,
                      child: _submitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              "Ambil Antrean",
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

  String? _birthDateToIso(String input) {
    final trimmed = input.trim();

    if (trimmed.isEmpty) return null;

    final parts = trimmed.split('/');

    if (parts.length != 3) return null;

    final dd = int.tryParse(parts[0]);
    final mm = int.tryParse(parts[1]);
    final yyyy = int.tryParse(parts[2]);

    if (dd == null || mm == null || yyyy == null) return null;
    if (yyyy < 1900 || yyyy > 2100) return null;
    if (mm < 1 || mm > 12) return null;
    if (dd < 1 || dd > 31) return null;

    final yyyyStr = yyyy.toString().padLeft(4, '0');
    final mmStr = mm.toString().padLeft(2, '0');
    final ddStr = dd.toString().padLeft(2, '0');

    final iso = '$yyyyStr-$mmStr-$ddStr';

    final dt = DateTime.tryParse(iso);

    if (dt == null || dt.year != yyyy || dt.month != mm || dt.day != dd) {
      return null;
    }

    return iso;
  }

  Future<void> _submitQueueAndShowDialog(BuildContext context) async {
    final birthIso = _birthDateToIso(_tglLahirController.text);

    if (birthIso == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal lahir tidak valid')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final queueNumber =
          "B-${(DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0')}";

      await HospitalApi().createQueue(
        scheduleId: widget.scheduleId!,
        queueNumber: queueNumber,
        scheduleDate: widget.scheduleDateIso!,
        patientName: _namaController.text.trim(),
        patientNik: _nikController.text.trim(),
        patientBirthDate: birthIso,
      );

      if (!mounted) return;

      setState(() => _submitting = false);

      _showAntreanDialog(context, forcedQueueNumber: queueNumber);
    } catch (e) {
      if (!mounted) return;

      setState(() => _submitting = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil antrean: $e')));
    }
  }

  Future<void> _downloadTicket({
    required GlobalKey boundaryKey,
    required String queueNumber,
  }) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception("Gagal menemukan widget untuk dirender.");
      }
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception("Gagal mengonversi gambar ke PNG.");
      }
      final bytes = byteData.buffer.asUint8List();

      await saveBytesAsFile(
        bytes: bytes,
        filename: 'tiket-antrean-$queueNumber.png',
        mimeType: 'image/png',
      );

      if (mounted) {
        _showSuccessSnackbar(context);
      }
    } catch (e, stackTrace) {
      debugPrint('Download error: $e');
      debugPrint('$stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengunduh tiket: $e')));
      }
    }
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

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    IconData? icon,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    FocusNode? focusNode,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      onTap: onTap,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.red),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: icon != null
            ? Icon(icon, color: Colors.grey, size: 20)
            : null,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  void _showAntreanDialog(BuildContext context, {String? forcedQueueNumber}) {
    final String noAntrean =
        forcedQueueNumber ??
        "B-${(DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0')}";
    final GlobalKey boundaryKey = GlobalKey();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                key: boundaryKey,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.namaRS,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "NOMOR ANTREAN",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 24),

                      _dashedDivider(),

                      const SizedBox(height: 16),

                      Text(
                        noAntrean,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1.0,
                        ),
                      ),

                      const SizedBox(height: 16),

                      _dashedDivider(),

                      const SizedBox(height: 24),

                      Text(
                        widget.selectedPoli ?? "-",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        widget.selectedDate ?? "-",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        "Harap datang sebelum nomor\ndipanggil",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D6EFD),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.file_download_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await _downloadTicket(
                          boundaryKey: boundaryKey,
                          queueNumber: noAntrean,
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D6EFD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(
                            dialogContext,
                            rootNavigator: true,
                          ).pop();

                          Navigator.of(context).popUntil(
                            (route) =>
                                route.settings.name == '/rs-detail' ||
                                route.isFirst,
                          );
                        },
                        child: const Text(
                          "Selesai",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dashedDivider() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();

        const dashWidth = 5.0;
        const dashHeight = 1.0;

        final dashCount = (boxWidth / (2 * dashWidth)).floor();

        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }

  void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFF4F8FF),
        elevation: 0,
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5EFFF)),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D6EFD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 24),
            ),

            const SizedBox(width: 16),

            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sukses",
                    style: TextStyle(
                      color: Color(0xFF0D6EFD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Nomor antrean berhasil diunduh.",
                    style: TextStyle(color: Color(0xFF0D6EFD), fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
