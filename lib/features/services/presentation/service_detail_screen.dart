import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:majadigi/features/home/model/service_model.dart';
import 'package:majadigi/core/theme/app_colors.dart';
import '../../../core/widgets/custom_wave_header.dart';
import '../../../core/widgets/custom_tab_selector.dart';
import '../../../core/widgets/custom_info_card.dart';
import '../../../core/widgets/custom_accordion_widget.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailScreen({Key? key, required this.service}) : super(key: key);

  static const Color primaryBlue = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    int selectedTabIndex = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: service.title,
            onSavePressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${service.title} disimpan ke bookmark.')),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  _buildLogo(),
                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              service.category,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                                height: 1.6,
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

                            if (selectedTabIndex == 0) _buildLayananTab(context),
                            if (selectedTabIndex == 1) _buildOperasionalTab(context),
                            if (selectedTabIndex == 2) _buildKetentuanUmumTab(context),

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

  Widget _buildLogo() {
    if (service.assetPath != null) {
      if (service.assetPath!.toLowerCase().endsWith('.svg')) {
        return SvgPicture.asset(
          service.assetPath!,
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        );
      } else {
        return Image.asset(
          service.assetPath!,
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        );
      }
    } else {
      return Icon(service.icon, size: 120, color: primaryBlue);
    }
  }

  Widget _buildLayananTab(BuildContext context) {
    // Determine layout/form based on service type
    bool isRSUD = service.title.contains('RSUD');
    bool isIslamic = service.title.contains('Islamic');
    bool isSidita = service.title.contains('Sidita');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Form Layanan Online - ${service.title}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 8),
        Text(
          isRSUD
              ? 'Gunakan form ini untuk melakukan pendaftaran antrean poliklinik atau konsultasi medis secara mandiri.'
              : isIslamic
                  ? 'Silakan isi form berikut untuk melakukan reservasi ruang serbaguna atau pendaftaran kajian keagamaan.'
                  : 'Gunakan form berikut untuk pengajuan bantuan disabilitas atau pengecekan status penyaluran bantuan alat.',
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.4),
        ),
        const SizedBox(height: 20),
        if (isRSUD) _buildRSUDForm(context),
        if (isIslamic) _buildIslamicForm(context),
        if (isSidita) _buildSiditaForm(context),
      ],
    );
  }

  Widget _buildRSUDForm(BuildContext context) {
    final nameController = TextEditingController();
    final nikController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Nama Lengkap Pasien',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Nama tidak boleh kosong' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: nikController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: 'NIK Pasien (16 Digit)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.credit_card),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'NIK tidak boleh kosong';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                return 'NIK harus berupa angka saja';
              }
              if (v.length != 16) {
                return 'NIK harus tepat 16 digit';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Poliklinik Tujuan',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.local_pharmacy),
            ),
            items: const [
              DropdownMenuItem(value: 'Spesialis Penyakit Dalam', child: Text('Spesialis Penyakit Dalam')),
              DropdownMenuItem(value: 'Spesialis Anak', child: Text('Spesialis Anak')),
              DropdownMenuItem(value: 'Spesialis Bedah Umum', child: Text('Spesialis Bedah Umum')),
              DropdownMenuItem(value: 'Poliklinik Gigi & Mulut', child: Text('Poliklinik Gigi & Mulut')),
            ],
            onChanged: (val) {},
            validator: (v) => v == null ? 'Pilih poliklinik tujuan' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pendaftaran Pendaftaran Poliklinik Berhasil Dikirim!'),
                    backgroundColor: Colors.green,
                  ),
                );
                nameController.clear();
                nikController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Daftar Antrean Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildIslamicForm(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Nama Pemohon / Organisasi',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.business),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Nama pemohon tidak boleh kosong' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Nomor Telepon / WhatsApp',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.phone),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Jenis Keperluan',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.event),
            ),
            items: const [
              DropdownMenuItem(value: 'Sewa Aula Pertemuan', child: Text('Sewa Aula Pertemuan')),
              DropdownMenuItem(value: 'Pendaftaran Kajian Akbar', child: Text('Pendaftaran Kajian Akbar')),
              DropdownMenuItem(value: 'Bimbingan Konseling Keagamaan', child: Text('Bimbingan Konseling Keagamaan')),
            ],
            onChanged: (val) {},
            validator: (v) => v == null ? 'Pilih jenis keperluan' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Permohonan Reservasi / Pendaftaran Berhasil Dikirim!'),
                    backgroundColor: Colors.green,
                  ),
                );
                nameController.clear();
                phoneController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Kirim Pengajuan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSiditaForm(BuildContext context) {
    final nikController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nikController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: 'Masukkan NIK Penyandang Disabilitas',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.search),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'NIK tidak boleh kosong';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                return 'NIK harus berupa angka saja';
              }
              if (v.length != 16) {
                return 'NIK harus tepat 16 digit';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Status Penerimaan Sidita'),
                    content: const Text(
                      'NIK terdaftar! Status: Bantuan Kursi Roda Elektrik disetujui dan sedang dalam proses pengiriman oleh Dinas Sosial Jawa Timur.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cari Status Bantuan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildOperasionalTab(BuildContext context) {
    final String address = _getAddress();
    final String hours = _getHours();
    final String link = _getLink();

    return Column(
      children: [
        CustomInfoCard(
          title: "Link Layanan",
          subtitle: link,
          isLink: true,
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          title: "Alamat Kantor/Pusat",
          subtitle: address,
        ),
        const SizedBox(height: 12),
        CustomInfoCard(
          title: "Jam Operasional",
          subtitle: hours,
        ),
      ],
    );
  }

  Widget _buildKetentuanUmumTab(BuildContext context) {
    final String benefits = _getBenefits();
    final String terms = _getTerms();

    return Column(
      children: [
        CustomAccordionWidget(
          title: 'Manfaat Layanan',
          content: benefits,
        ),
        const SizedBox(height: 12),
        CustomAccordionWidget(
          title: 'Persyaratan & Ketentuan',
          content: terms,
        ),
      ],
    );
  }

  // --- MOCK DATA HELPER METHODS ---

  String _getAddress() {
    if (service.title.contains('Soetomo')) {
      return 'Jl. Mayjen Prof. Dr. Moestopo No.6-8, Gubeng, Kec. Gubeng, Surabaya, Jawa Timur 60286';
    } else if (service.title.contains('Saiful Anwar')) {
      return 'Jl. Jaksa Agung Suprapto No.2, Klojen, Kec. Klojen, Kota Malang, Jawa Timur 65112';
    } else if (service.title.contains('Daha Husada')) {
      return 'Jl. Veteran No.85, Mojoroto, Kec. Mojoroto, Kota Kediri, Jawa Timur 64112';
    } else if (service.title.contains('Islamic')) {
      return 'Jl. Dukuh Kupang XX No.122, Dukuh Pakis, Kec. Dukuhpakis, Surabaya, Jawa Timur 60225';
    } else if (service.title.contains('Karsa Husada')) {
      return 'Jl. A. Yani No.18, Ngaglik, Kec. Batu, Kota Batu, Jawa Timur 65311';
    } else if (service.title.contains('Sidita')) {
      return 'Dinas Sosial Provinsi Jawa Timur, Jl. Gayung Kebonsari No.56b, Surabaya, Jawa Timur 60235';
    } else if (service.title.contains('Haji')) {
      return 'Jl. Manyar Kertoadi No.1, Klampis Ngasem, Kec. Sukolilo, Surabaya, Jawa Timur 60116';
    }
    return 'Provinsi Jawa Timur, Indonesia';
  }

  String _getHours() {
    if (service.title.contains('Haji') || service.title.contains('Karsa Husada')) {
      return 'Senin - Minggu : 24 Jam (IGD/Rawat Inap)';
    } else if (service.title.contains('Islamic')) {
      return 'Senin - Minggu : 08.00 - 21.00 WIB';
    } else if (service.title.contains('Daha Husada')) {
      return 'Senin - Sabtu : 08.00 - 20.00 WIB';
    }
    return 'Senin - Jumat : 07.30 - 15.00 WIB';
  }

  String _getLink() {
    if (service.title.contains('Soetomo')) {
      return 'https://rsuddrsoetomo.jatimprov.go.id/';
    } else if (service.title.contains('Saiful Anwar')) {
      return 'https://rsusaifulanwar.jatimprov.go.id/v2/';
    } else if (service.title.contains('Daha Husada')) {
      return 'https://rsuddahahusada.jatimprov.go.id/';
    } else if (service.title.contains('Islamic')) {
      return 'https://islamiccenter.jatimprov.go.id/';
    } else if (service.title.contains('Karsa Husada')) {
      return 'https://rsukarsahusadabatu.jatimprov.go.id/';
    } else if (service.title.contains('Sidita')) {
      return 'https://dinsos.jatimprov.go.id/';
    } else if (service.title.contains('Haji')) {
      return 'https://app.rsuhaji.jatimprov.go.id/online/';
    }
    return 'https://jatimprov.go.id/';
  }

  String _getBenefits() {
    if (service.title.contains('RSUD')) {
      return '1. Memudahkan pendaftaran antrean berobat secara mandiri tanpa harus antre langsung.\n2. Memberikan informasi secara cepat dan akurat mengenai ketersediaan tempat tidur rawat inap.\n3. Akses mudah ke dokter spesialis favorit melalui sistem reservasi online.';
    } else if (service.title.contains('Islamic')) {
      return '1. Memudahkan masyarakat dalam mereservasi fasilitas gedung Islamic Center secara resmi.\n2. Menyediakan akses jadwal kajian rutin, kegiatan dakwah, dan syiar Islam Jawa Timur.\n3. Layanan konseling keagamaan terpadu bersama asatidz berpengalaman.';
    } else if (service.title.contains('Sidita')) {
      return '1. Transparansi pendataan alat bantu bagi penyandang disabilitas (kursi roda, alat bantu dengar, kaki palsu).\n2. Mempercepat proses distribusi bantuan secara tepat sasaran.\n3. Informasi lowongan pelatihan vokasional khusus disabilitas.';
    }
    return 'Memberikan kemudahan akses pelayanan publik, transparansi informasi daerah, serta efisiensi waktu pendaftaran dan administrasi bagi seluruh warga Jawa Timur.';
  }

  String _getTerms() {
    if (service.title.contains('RSUD')) {
      return 'a. Memiliki kartu identitas KTP/BPJS Kesehatan aktif.\nb. Pendaftaran online dilakukan minimal H-1 sebelum jadwal periksa.\nc. Pasien diwajibkan datang 30 menit sebelum jam praktek dokter untuk melakukan verifikasi berkas.';
    } else if (service.title.contains('Islamic')) {
      return 'a. Pengajuan sewa tempat minimal dilakukan 14 hari sebelum hari pelaksanaan.\nb. Kegiatan yang dilaksanakan tidak melanggar nilai-nilai moral keagamaan dan hukum negara.\nc. Pendaftaran peserta kajian gratis namun wajib menjaga ketertiban umum.';
    } else if (service.title.contains('Sidita')) {
      return 'a. Merupakan warga Provinsi Jawa Timur yang dibuktikan dengan KTP/KK.\nb. Terdaftar sebagai penyandang disabilitas di pangkalan data Dinas Sosial Jawa Timur.\nc. Pengajuan alat bantu disertai dengan surat rekomendasi dokter atau instansi sosial setempat.';
    }
    return 'a. Merupakan warga negara Indonesia atau memiliki dokumen legal daerah setempat.\nb. Mengisi data form pengajuan dengan jujur dan valid.\nc. Mengikuti alur operasional masing-masing unit layanan.';
  }
}
