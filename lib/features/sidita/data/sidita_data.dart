import 'dart:ui';
import '../models/wisata_model.dart';

class SiditaData {
  static final Map<String, String> operasionalData = const {
    "link": "https://sidita.disbudpar.jatimprov.go.id/",
    "alamat":
        "Jalan Wisata Menanggal, Dukuh Menanggal, Kec. Gayungan, Kota Surabaya, Provinsi Jawa Timur 60234",
    "jam": "Senin - Minggu : 24 Jam",
  };

  static final List<Map<String, String>> ketentuanData = const [
    {
      "title": "Manfaat",
      "content":
          "SIDITA memberikan kemudahan akses informasi destinasi pariwisata yang ada di Jawa Timur.",
    },
    {
      "title": "Pendaftaran Online",
      "content":
          "Anda dapat melakukan pendaftaran online melalui portal resmi SIDITA.",
    },
  ];

  static final Map<String, String> headerData = const {
    "title": "Destinasi Wisata",
    "subtitle": "Pusat informasi dan promosi wisata Jawa Timur",
    "mainTitle": "Pariwisata Jawa Timur",
  };

  static final List<WisataModel> wisataList = const [
    // Trenggalek
    WisataModel(
      namaWisata: "Pantai Pasir Putih Karanggongso",
      wilayah: "Trenggalek",
      status: "Berbayar",
      jamOperasional: "07.00 – 18.00",
      image: "assets/images/pasir_putih.jpg",
      pinPosition: Offset(0.2885, 0.3199),
      isPaid: true,
      deskripsi:
          "Destinasi wisata keluarga paling populer di Trenggalek. Pantai ini memiliki pasir putih yang landai dan ombak yang sangat tenang karena berada di area teluk. Fasilitasnya sangat lengkap, mulai dari penyewaan perahu wisata hingga deretan warung kuliner ikan asap segar di pinggir pantai.",
      hargaTiket: 15000,
      rating: 8.7,
      alamat: "Jl. Raya Karanggongso, Tasikmadu, Watulimo, Trenggalek",
    ),
    WisataModel(
      namaWisata: "Alam indah pantai kuteng",
      wilayah: "Trenggalek",
      status: "Gratis",
      jamOperasional: "06.00 – 17.00",
      image: "assets/images/alam_indah.jpg",
      pinPosition: Offset(0.6123, 0.4628),
      isPaid: false,
      deskripsi:
          "Sebuah hidden gem atau pantai tersembunyi yang suasananya masih sangat alami, sepi, and asri. Dikelilingi oleh perbukitan hijau and vegetasi yang rapat, tempat ini sangat cocok untuk wisatawan yang ingin menikmati ketenangan jauh dari keramaian kota.",
      hargaTiket: 0,
      rating: 8.1,
      alamat: "Jl. Pantai Kuteng, Watulimo, Trenggalek",
    ),
    WisataModel(
      namaWisata: "Pantai Mutiara",
      wilayah: "Trenggalek",
      status: "Berbayar",
      jamOperasional: "06.00 – 17.30",
      image: "assets/images/pantai_mutiara.jpg",
      pinPosition: Offset(0.3554, 0.6049),
      isPaid: true,
      deskripsi:
          "Pantai yang menawarkan pesona pasir putih bersih berpadu dengan pepohonan rindang and ombak yang aman. Pantai ini menjadi spot favorit untuk berbagai aktivitas olahraga air seperti bermain kano, banana boat, hingga bersantai menikmati pemandangan matahari terbenam (sunset).",
      hargaTiket: 10000,
      rating: 8.4,
      alamat: "Jl. Raya Pantai Mutiara, Tasikmadu, Watulimo, Trenggalek",
    ),

    // Kediri
    WisataModel(
      namaWisata: "Air Terjun Dolo",
      wilayah: "Kediri",
      status: "Berbayar",
      jamOperasional: "07.00 – 17.30",
      image: "assets/images/airterjun_dolo.jpg",
      pinPosition: Offset(0.1950, 0.2890),
      isPaid: true,
      deskripsi:
          "Destinasi wisata alam tersembunyi yang terletak di kawasan lereng Gunung Wilis. Air terjun ini menawarkan suasana sejuk dengan gemercik air yang dingin serta pemandangan hijau yang asri. Untuk mencapai titik air terjun, wisatawan perlu berjalan kaki menuruni ratusan anak tangga batu yang tertata rapi.",
      hargaTiket: 10000,
      rating: 8.5,
      alamat: "Dusun Besuki, Desa Jugo, Kec. Mojo, Kediri",
    ),
    WisataModel(
      namaWisata: "Alun-Alun Kota Kediri",
      wilayah: "Kediri",
      status: "Gratis",
      jamOperasional: "24 jam",
      image: "assets/images/alun_kediri.jpg",
      pinPosition: Offset(0.7927, 0.1253),
      isPaid: false,
      pinTextDirection: PinTextDirection.leftBottom,
      deskripsi:
          "Pusat ruang publik and tempat berkumpulnya masyarakat di jantung Kota Kediri. Lokasinya sangat strategis and menjadi spot favorit untuk bersantai, berolahraga ringan, atau menikmati berbagai kuliner lokal khas Kediri yang dijajakan oleh pedagang di sekitar area luar taman, terutama saat sore and malam hari.",
      hargaTiket: 0,
      rating: 8.2,
      alamat: "Jl. Panglima Sudirman, Kampung Dalem, Kediri",
    ),
    WisataModel(
      namaWisata: "Simpang Lima Gumul",
      wilayah: "Kediri",
      status: "Gratis",
      jamOperasional: "07.00 – 22.00",
      image: "assets/images/simpang_gumul.jpg",
      pinPosition: Offset(0.9627, 0.0755),
      isPaid: false,
      pinTextDirection: PinTextDirection.left,
      deskripsi:
          "Monumen megah yang menjadi ikon serta simbol kemajuan Kabupaten Kediri. Desain arsitekturnya yang sekilas mirip dengan Arc de Triomphe di Paris menjadikannya spot foto paling populer. Area di sekitar monumen juga sering dimanfaatkan sebagai pusat kegiatan seni, festival, and rekreasi keluarga.",
      hargaTiket: 0,
      rating: 8.6,
      alamat: "Kawasan Simpang Lima Gumul, Tugurejo, Ngasem, Kediri",
    ),

    // Malang
    WisataModel(
      namaWisata: "Museum Angkut",
      wilayah: "Malang",
      status: "Berbayar",
      jamOperasional: "12.00 – 20.00",
      image: "assets/images/museum_angkut.jpg",
      pinPosition: Offset(0.0800, 0.1600),
      isPaid: true,
      deskripsi:
          "Museum transportasi pertama and terbesar di Asia Tenggara yang terletak di Kota Batu. Tempat ini memamerkan ratusan koleksi kendaraan klasik hingga modern dari berbagai belahan dunia yang dipadukan dengan latar belakang zona-zona tematik yang ikonik, seperti zona Hollywood, Gangster Town, and Eropa.",
      hargaTiket: 100000,
      rating: 9.2,
      alamat: "Jl. Terusan Sultan Agung No. 2, Ngaglik, Kec. Batu, Kota Batu",
    ),
    WisataModel(
      namaWisata: "Gunung Bromo",
      wilayah: "Malang",
      status: "Berbayar",
      jamOperasional: "24 jam",
      image: "assets/images/bromo.jpg",
      pinPosition: Offset(0.8487, 0.2848),
      isPaid: true,
      pinTextDirection: PinTextDirection.left,
      deskripsi:
          "Salah satu gunung berapi aktif paling terkenal di Indonesia yang menawarkan pemandangan magis lautan pasir seluas 10 kilometer persegi. Wisatawan biasanya mengincar momen matahari terbit (sunrise) yang memukau dari berbagai titik pandang, lalu melanjutkan petualangan mendaki ke bibir kawah aktif.",
      hargaTiket: 30000,
      rating: 9.5,
      alamat: "Kawasan Taman Nasional Bromo Tengger Semeru, Malang",
    ),
    WisataModel(
      namaWisata: "Air Terjun Coban Pelangi",
      wilayah: "Malang",
      status: "Berbayar",
      jamOperasional: "08.00 – 16.00",
      image: "assets/images/coban_pelangi.jpg",
      pinPosition: Offset(0.6759, 0.4928),
      isPaid: true,
      deskripsi:
          "Destinasi wisata alam berupa air terjun indah yang dikelilingi oleh vegetasi hutan pinus yang asri. Keunikan utamanya adalah fenomena bias sinar matahari yang sering memunculkan pelangi di sekitar cipratan air terjun, terutama jika dikunjungi antara pukul 10.00 hingga 14.00 WIB saat cuaca cerah.",
      hargaTiket: 15000,
      rating: 8.6,
      alamat: "Dusun Besuki, Desa Jugo, Kec. Poncokusumo, Malang",
    ),
  ];
}
