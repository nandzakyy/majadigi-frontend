import 'package:flutter/material.dart';

class RumahSakitData {
  static final List<Map<String, String>> rsList = [
    {"nama": "RSUD Dr Soetomo", "alamat": "Surabaya", "logoPath": "assets/images/rsud_soetomo.png"},
    {"nama": "RSUD Karsa Husada", "alamat": "Malang", "logoPath": "assets/images/rsud_karsa.png"},
    {"nama": "RSUD Dr Saiful Anwar", "alamat": "Malang", "logoPath": "assets/images/rsud_saiful.png"},
    {"nama": "RSUD Haji Prov. Jatim", "alamat": "Surabaya", "logoPath": "assets/images/rsud_haji.png"},
    {"nama": "RSUD Daha Husada", "alamat": "Kediri", "logoPath": "assets/images/rsud_daha.png"},
  ];

  static final Map<String, Map<String, String>> rsDetailData = const {
    "RSUD Dr Soetomo": {
      "deskripsi": "Rumah Sakit rujukan layanan kesehatan berstatus A di Jawa Timur",
      "link": "https://rsudrsoetomo.jatimprov.go.id/",
      "alamat": "Jl. Mayjend. Prof. Dr. Moestopo No. 6-8, Kec. Gubeng, Surabaya",
      "jam": "Senin - Minggu: 24 Jam",
    },
    "RSUD Daha Husada": {
      "deskripsi": "RSUD Daha Husada Kota Kediri",
      "link": "https://rsuddahahusada.jatimprov.go.id/",
      "alamat": "Jl. Veteran No.48, Mojoroto, Kediri",
      "jam": "Senin - Jumat: 07.00 - 21.00 WIB",
    },
    "RSUD Haji Prov. Jatim": {
      "deskripsi": "Rumah sakit tipe B pendidikan milik Pemerintah Provinsi Jawa Timur dengan status BLUD",
      "link": "https://app.rsuhaji.jatimprov.go.id/online/",
      "alamat": "Jl. Manyar Kertoadi, Sukolilo, Surabaya",
      "jam": "Senin - Minggu: 24 Jam",
    },
    "RSUD Dr Saiful Anwar": {
      "deskripsi": "RSUD DR. Saiful Anwar Provinsi Jawa Timur",
      "link": "https://rsusaifulanwar.jatimprov.go.id/v2/",
      "alamat": "Jl. Jaksa Agung Suprapto No.2, Malang",
      "jam": "Senin - Minggu: 24 Jam",
    },
    "RSUD Karsa Husada": {
      "deskripsi": "Rumah sakit tipe B yang melayani masyarakat di Kota Batu, Jawa Timur",
      "link": "https://rsukarsahusadabatu.jatimprov.go.id/",
      "alamat": "Jl. A. Yani No.10-13, Batu",
      "jam": "Senin - Minggu: 24 Jam",
    },
  };

  static final List<String> poliList = [
    "Poli Umum",
    "Poli Gigi",
    "Poli Anak",
    "Poli Kandungan",
    "Poli Penyakit Dalam",
  ];

  static final List<String> dokterList = [
    "Dr. Andi (08:00 - 12:00)",
    "Dr. Budi (13:00 - 17:00)",
    "Dr. Citra (18:00 - 21:00)",
  ];

  static final List<Map<String, dynamic>> kamarData = [
    {"name": "HCU", "color": Colors.blue, "kapasitas": 123, "terisi": 83, "tersedia": 40},
    {"name": "ISOLASI", "color": Colors.red, "kapasitas": 42, "terisi": 30, "tersedia": 12},
    {"name": "KB", "color": Colors.green, "kapasitas": 3, "terisi": 0, "tersedia": 3},
    {"name": "KELAS I", "color": Colors.indigo, "kapasitas": 127, "terisi": 104, "tersedia": 23},
    {"name": "KELAS II", "color": Colors.lightBlue, "kapasitas": 77, "terisi": 48, "tersedia": 29},
    {"name": "KELAS III", "color": Colors.blue.shade200, "kapasitas": 453, "terisi": 367, "tersedia": 89},
    {"name": "ICU", "color": Colors.red.shade900, "kapasitas": 66, "terisi": 51, "tersedia": 15},
    {"name": "Utama I", "color": Colors.blue, "kapasitas": 10, "terisi": 1, "tersedia": 9},
    {"name": "VIP", "color": Colors.orange, "kapasitas": 101, "terisi": 75, "tersedia": 26},
    {"name": "Utama II", "color": Colors.lightBlue, "kapasitas": 6, "terisi": 3, "tersedia": 3},
    {"name": "Super VVIP I", "color": Colors.orange, "kapasitas": 6, "terisi": 1, "tersedia": 5},
    {"name": "Super VVIP II", "color": Colors.orange.shade700, "kapasitas": 6, "terisi": 6, "tersedia": 0},
    {"name": "HCU Privat", "color": Colors.indigo, "kapasitas": 4, "terisi": 3, "tersedia": 1},
    {"name": "Non Kelas", "color": Colors.grey, "kapasitas": 6, "terisi": 1, "tersedia": 5},
  ];

  static final List<Map<String, String>> ketentuanData = const [
    {
      "title": "Manfaat",
      "content": "Isi detail...",
    },
    {
      "title": "Pendaftaran Online",
      "content": "Isi detail...",
    },
  ];
}
