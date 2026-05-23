import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:majadigi/features/home/model/service_model.dart';
import 'package:majadigi/core/theme/app_colors.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailScreen({Key? key, required this.service}) : super(key: key);

  static const Color primaryBlue = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        _buildLogo(),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            service.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            service.category,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.6),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildTabSelector(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildLayananTab(context),
                        _buildOperasionalTab(context),
                        _buildKetentuanUmumTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    service.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${service.title} disimpan ke bookmark.')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 6)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFE6F0FF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: service.assetPath != null
                ? (service.assetPath!.toLowerCase().endsWith('.svg')
                    ? SvgPicture.asset(
                        service.assetPath!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        service.assetPath!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                      ))
                : Icon(service.icon, size: 72, color: primaryBlue),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        labelColor: primaryBlue,
        unselectedLabelColor: const Color(0xFF6B7280),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        tabs: const [
          Tab(text: 'Layanan'),
          Tab(text: 'Operasional'),
          Tab(text: 'Ketentuan'),
        ],
      ),
    );
  }

  Widget _buildLayananTab(BuildContext context) {
    // Determine layout/form based on service type
    bool isRSUD = service.title.contains('RSUD');
    bool isIslamic = service.title.contains('Islamic');
    bool isSidita = service.title.contains('Sidita');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
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
      ),
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
            decoration: InputDecoration(
              labelText: 'NIK Pasien (16 Digit)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.credit_card),
            ),
            validator: (v) => v == null || v.length != 16 ? 'NIK harus 16 digit' : null,
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
            decoration: InputDecoration(
              labelText: 'Masukkan NIK Penyandang Disabilitas',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.search),
            ),
            validator: (v) => v == null || v.length != 16 ? 'NIK harus 16 digit' : null,
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
    // Custom info maps for operasional details
    final String address = _getAddress();
    final String hours = _getHours();
    final String link = _getLink();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoTile(context, label: 'Link Layanan', content: link, isLink: true),
          const SizedBox(height: 16),
          _buildInfoTile(context, label: 'Alamat Kantor/Pusat', content: address),
          const SizedBox(height: 16),
          _buildInfoTile(context, label: 'Jam Operasional', content: hours),
        ],
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, {required String label, required String content, bool isLink = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: isLink
              ? InkWell(
                  onTap: () async {
                    final uri = Uri.parse(content);
                    final messenger = ScaffoldMessenger.of(context);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Gagal membuka link')),
                      );
                    }
                  },
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 14, color: primaryBlue, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                  ),
                )
              : Text(
                  content,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.6),
                ),
        ),
      ],
    );
  }

  Widget _buildKetentuanUmumTab(BuildContext context) {
    final String benefits = _getBenefits();
    final String terms = _getTerms();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          _buildExpansionCard(
            context: context,
            title: 'Manfaat Layanan',
            content: benefits,
          ),
          const SizedBox(height: 16),
          _buildExpansionCard(
            context: context,
            title: 'Persyaratan & Ketentuan',
            content: terms,
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionCard({required BuildContext context, required String title, required String content}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 5)),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        collapsedIconColor: primaryBlue,
        iconColor: primaryBlue,
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.7),
            ),
          ),
        ],
      ),
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
      return 'https://rsusaifulanwar.jatimprov.go.id/';
    } else if (service.title.contains('Daha Husada')) {
      return 'https://rsuddahahusada.jatimprov.go.id/';
    } else if (service.title.contains('Islamic')) {
      return 'https://islamiccenter.jatimprov.go.id/';
    } else if (service.title.contains('Karsa Husada')) {
      return 'https://rsudkarsahusadabatu.jatimprov.go.id/';
    } else if (service.title.contains('Sidita')) {
      return 'https://dinsos.jatimprov.go.id/';
    } else if (service.title.contains('Haji')) {
      return 'https://rsuhaji.jatimprov.go.id/';
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
