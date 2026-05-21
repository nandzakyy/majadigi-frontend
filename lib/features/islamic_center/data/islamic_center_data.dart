import '../models/fasilitas_gedung_model.dart';
import '../models/detail_fasilitas_gedung_model.dart';

class IslamicCenterData {
  // Data Layanan Utama (Operasional)
  static const String linkLayanan = "https://islamiccenter.jatimprov.go.id/";
  static const String alamat = "Jl. Raya Dukuh Kupang No.122-124, Kec. Dukuhpakis, Surabaya";
  static const String jamOperasional = "Senin - Minggu: 24 Jam";

  // Data Fasilitas Gedung
  static final List<FasilitasGedungModel> fasilitasGedungList = [
    FasilitasGedungModel(
      nama: "Aula",
      deskripsi:
          "Islamic Centre Jawa Timur menyediakan beragam ruangan sesuai dengan kebutuhan Anda baik pertemuan formal maupun perayaan acara besar.",
      tags: ["Hall Utama", "Ruang VIP", "+ 2"],
      imagePath: "assets/images/rsud_soetomo.png",
    ),
    FasilitasGedungModel(
      nama: "Asrama",
      deskripsi:
          "Islamic Centre Jawa Timur menyediakan beragam ruangan sesuai dengan kebutuhan Anda baik pertemuan formal maupun perayaan acara besar.",
      tags: ["Kamar 2 Bed", "Kamar 4 Bed", "+ 1"],
      imagePath: "assets/images/rsud_soetomo.png",
    ),
    FasilitasGedungModel(
      nama: "Ruangan Masjid",
      deskripsi:
          "Islamic Centre Jawa Timur menyediakan beragam ruangan sesuai dengan kebutuhan Anda baik pertemuan formal maupun perayaan acara besar.",
      tags: ["Ruang VIP", "Akad Nikah + Petugas", "+ 1"],
      imagePath: "assets/images/rsud_soetomo.png",
    ),
  ];

  // Data Detail Fasilitas - Ruangan Masjid
  static final List<DetailFasilitasGedungModel> ruanganMasjidList = [
    DetailFasilitasGedungModel(
      title: "Ruang VIP Masjid",
      kapasitas: "100 Orang",
      tarif: "Rp3.000.000",
      imagePath: "assets/images/rsud_soetomo.png",
      deskripsi: "Ruang VIP Masjid Islamic Center Jawa Timur adalah ruang eksklusif dengan kapasitas hingga 100 orang, ideal untuk acara formal, pertemuan bisnis, atau kegiatan yang memerlukan suasana lebih intim dan privat. Dengan harga sewa per jam, ruang VIP ini menawarkan kenyamanan maksimal dan suasana mewah yang akan mendukung kesuksesan acara kamu.",
    ),
    DetailFasilitasGedungModel(
      title: "Akad Nikah + Petugas",
      kapasitas: "100 Orang",
      tarif: "Rp3.500.000",
      imagePath: "assets/images/rsud_soetomo.png",
      deskripsi: "Islamic Center Jawa Timur menawarkan paket lengkap untuk acara akad nikah, dengan kapasitas hingga 100 orang. Paket ini mencakup ruang yang nyaman serta layanan petugas yang akan membantu kelancaran prosesi akad nikah. Dengan harga sewa per jam, paket ini memberikan pengalaman pernikahan yang sempurna dan lancar.",
    ),
    DetailFasilitasGedungModel(
      title: "Area Luar Masjid",
      kapasitas: "100 Orang",
      tarif: "Rp2.500.000",
      imagePath: "assets/images/rsud_soetomo.png",
      deskripsi: "Area Luar Masjid Islamic Center Jawa Timur adalah ruang terbuka yang cocok untuk berbagai acara, seperti perayaan atau kegiatan luar ruangan lainnya. Dengan kapasitas hingga 100 orang, area luar masjid ini memberikan fleksibilitas dalam menyelenggarakan acara kamu, baik itu dalam suasana santai atau formal.",
    ),
  ];

  // Data Detail Fasilitas - Aula
  static final List<DetailFasilitasGedungModel> aulaList = [
    DetailFasilitasGedungModel(
      title: "Hall Utama",
      kapasitas: "300 Orang",
      tarif: "Rp5.000.000",
      imagePath: "assets/images/rsud_soetomo.png",
      deskripsi: "Hall Utama Islamic Center Jawa Timur merupakan aula utama berkapasitas besar yang cocok digunakan untuk seminar, konferensi, wisuda, maupun acara formal lainnya dengan fasilitas lengkap dan nyaman.",
    ),
    DetailFasilitasGedungModel(
      title: "Ruang Rapat",
      kapasitas: "50 Orang",
      tarif: "Rp1.500.000",
      imagePath: "assets/images/rsud_soetomo.png",
      deskripsi: "Ruang Rapat Islamic Center Jawa Timur dirancang untuk kebutuhan meeting dan diskusi formal dengan suasana nyaman serta fasilitas pendukung presentasi.",
    ),
    DetailFasilitasGedungModel(
      title: "Ruang VIP",
      kapasitas: "30 Orang",
      tarif: "Rp2.500.000",
      imagePath: "assets/images/rsud_soetomo.png",
      deskripsi: "Ruang VIP Islamic Center Jawa Timur menyediakan ruangan eksklusif untuk tamu penting atau kegiatan privat dengan fasilitas premium.",
    ),
    DetailFasilitasGedungModel(
      title: "Ruang Kelas",
      kapasitas: "40 Orang",
      tarif: "Rp1.000.000",
      imagePath: "assets/images/rsud_soetomo.png",
      deskripsi: "Ruang Kelas Islamic Center Jawa Timur cocok digunakan untuk pelatihan, workshop, maupun kegiatan pembelajaran dengan suasana yang nyaman.",
    ),
  ];

  // Data Detail Fasilitas - Asrama
  static final List<DetailFasilitasGedungModel> asramaList = [
    DetailFasilitasGedungModel(
      title: "Kamar 2 Bed",
      kapasitas: "2 Orang",
      tarif: "Rp350.000",
      imagePath: "assets/images/rsud_soetomo.png",
      deskripsi: "Kamar 2 Bed Islamic Center Jawa Timur menyediakan kamar nyaman dengan kapasitas dua orang yang cocok untuk tamu maupun peserta kegiatan.",
    ),
    DetailFasilitasGedungModel(
      title: "Kamar 4 Bed",
      kapasitas: "4 Orang",
      tarif: "Rp500.000",
      imagePath: "assets/images/rsud_soetomo.png",
      deskripsi: "Kamar 4 Bed Islamic Center Jawa Timur cocok untuk rombongan kecil dengan fasilitas nyaman dan area istirahat yang bersih.",
    ),
    DetailFasilitasGedungModel(
      title: "Kamar 6 Bed",
      kapasitas: "6 Orang",
      tarif: "Rp700.000",
      imagePath: "assets/images/rsud_soetomo.png",
      deskripsi: "Kamar 6 Bed Islamic Center Jawa Timur dirancang untuk kebutuhan menginap rombongan dengan kapasitas lebih besar dan fasilitas lengkap.",
    ),
  ];
}
