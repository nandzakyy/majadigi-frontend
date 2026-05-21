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
      imagePath: "assets/images/aula.png",
    ),
    FasilitasGedungModel(
      nama: "Asrama",
      deskripsi:
          "Islamic Centre Jawa Timur menyediakan beragam ruangan sesuai dengan kebutuhan Anda baik pertemuan formal maupun perayaan acara besar.",
      tags: ["Kamar 2 Bed", "Kamar 4 Bed", "+ 1"],
      imagePath: "assets/images/asrama.png",
    ),
    FasilitasGedungModel(
      nama: "Ruangan Masjid",
      deskripsi:
          "Islamic Centre Jawa Timur menyediakan beragam ruangan sesuai dengan kebutuhan Anda baik pertemuan formal maupun perayaan acara besar.",
      tags: ["Ruang VIP", "Akad Nikah + Petugas", "+ 1"],
      imagePath: "assets/images/ruangan_masjid.png",
    ),
  ];

  // Data Detail Fasilitas - Ruangan Masjid
  static final List<DetailFasilitasGedungModel> ruanganMasjidList = [
    DetailFasilitasGedungModel(
      title: "Ruang VIP Masjid",
      capacity: "100 Orang",
      price: "Rp3.000.000",
      image: "assets/images/ruang_vip.png",
      description: "Ruang VIP Masjid Islamic Center Jawa Timur adalah ruang eksklusif dengan kapasitas hingga 100 orang, ideal untuk acara formal, pertemuan bisnis, atau kegiatan yang memerlukan suasana lebih intim dan privat. Dengan harga sewa per jam, ruang VIP ini menawarkan kenyamanan maksimal and suasana mewah yang akan mendukung kesuksesan acara kamu.",
    ),
    DetailFasilitasGedungModel(
      title: "Akad Nikah + Petugas",
      capacity: "100 Orang",
      price: "Rp3.500.000",
      image: "assets/images/akad_nikah.png",
      description: "Islamic Center Jawa Timur menawarkan paket lengkap untuk acara akad nikah, dengan kapasitas hingga 100 orang. Paket ini mencakup ruang yang nyaman serta layanan petugas yang akan membantu kelancaran prosesi akad nikah. Dengan harga sewa per jam, paket ini memberikan pengalaman pernikahan yang sempurna dan lancar.",
    ),
    DetailFasilitasGedungModel(
      title: "Area Luar Masjid",
      capacity: "100 Orang",
      price: "Rp2.500.000",
      image: "assets/images/area_luar_masjid.png",
      description: "Area Luar Masjid Islamic Center Jawa Timur adalah ruang terbuka yang cocok untuk berbagai acara, seperti perayaan atau kegiatan luar ruangan lainnya. Dengan kapasitas hingga 100 orang, area luar masjid ini memberikan fleksibilitas dalam menyelenggarakan acara kamu, baik itu dalam suasana santai atau formal.",
    ),
  ];

  // Data Detail Fasilitas - Aula
  static final List<DetailFasilitasGedungModel> aulaList = [
    DetailFasilitasGedungModel(
      title: "Hall Utama",
      capacity: "2.000 orang",
      price: "Rp10.000.000",
      image: "assets/images/aula.png",
      description: "Hall Utama Islamic Center Jawa Timur merupakan aula utama berkapasitas besar yang cocok digunakan untuk seminar, konferensi, wisuda, pernikahan, maupun acara formal lainnya dengan fasilitas lengkap dan nyaman.",
    ),
    DetailFasilitasGedungModel(
      title: "Ruang Rapat",
      capacity: "150 orang",
      price: "Rp2.000.000",
      image: "assets/images/aula.png",
      description: "Ruang Rapat Islamic Center Jawa Timur dirancang untuk kebutuhan meeting, seminar kecil, maupun diskusi formal dengan suasana nyaman serta fasilitas pendukung yang lengkap.",
    ),
    DetailFasilitasGedungModel(
      title: "Ruang VIP",
      capacity: "25 orang",
      price: "Rp1.500.000",
      image: "assets/images/aula.png",
      description: "Ruang VIP Islamic Center Jawa Timur menyediakan ruangan eksklusif untuk tamu penting atau kegiatan privat dengan fasilitas premium dan suasana nyaman.",
    ),
    DetailFasilitasGedungModel(
      title: "Ruang Kelas",
      capacity: "50 orang",
      price: "Rp1.000.000",
      image: "assets/images/aula.png",
      description: "Ruang Kelas Islamic Center Jawa Timur cocok digunakan untuk pelatihan, workshop, maupun kegiatan pembelajaran dengan suasana yang nyaman dan fasilitas pendukung yang lengkap.",
    ),
  ];

  // Data Detail Fasilitas - Asrama
  static final List<DetailFasilitasGedungModel> asramaList = [
    DetailFasilitasGedungModel(
      title: "Kamar 2 Bed",
      capacity: "2 orang",
      price: "Rp175.000",
      image: "assets/images/asrama.png",
      description: "Kamar 2 Bed Islamic Center Jawa Timur menawarkan kenyamanan dengan kapasitas untuk 2 orang. Kamar ini dilengkapi dengan fasilitas seperti AC, TV, meja, dan toilet luar, membuatnya ideal untuk grup atau keluarga yang membutuhkan ruang lebih besar. Suasana yang tenang dan fasilitas lengkap menjadikan kamar ini pilihan yang tepat untuk akomodasi jangka pendek.",
    ),
    DetailFasilitasGedungModel(
      title: "Kamar 4 Bed",
      capacity: "4 orang",
      price: "Rp175.000",
      image: "assets/images/asrama.png",
      description: "Kamar 4 Bed Islamic Center Jawa Timur menawarkan kenyamanan dengan kapasitas untuk 4 orang. Kamar ini dilengkapi dengan fasilitas seperti AC, TV, meja, dan toilet luar, membuatnya ideal untuk grup atau keluarga yang membutuhkan ruang lebih besar. Suasana yang tenang dan fasilitas lengkap menjadikan kamar ini pilihan yang tepat untuk akomodasi jangka pendek.",
    ),
    DetailFasilitasGedungModel(
      title: "Kamar 6 Bed",
      capacity: "6 orang",
      price: "Rp175.000",
      image: "assets/images/asrama.png",
      description: "Kamar 6 Bed Islamic Center Jawa Timur menawarkan kenyamanan dengan kapasitas untuk 6 orang. Kamar ini dilengkapi dengan fasilitas seperti AC, TV, meja, dan toilet luar, membuatnya ideal untuk grup atau keluarga yang membutuhkan ruang lebih besar. Suasana yang tenang dan fasilitas lengkap menjadikan kamar ini pilihan yang tepat untuk akomodasi jangka pendek.",
    ),
  ];
}
