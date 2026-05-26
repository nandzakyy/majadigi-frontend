import 'dart:ui';

enum PinTextDirection {
  right,
  left,
  leftBottom,
}

class WisataModel {
  final String namaWisata;
  final String wilayah;
  final String status;
  final String jamOperasional;
  final String image;
  final Offset pinPosition; // Relative offset where dx, dy are values between 0.0 and 1.0
  final bool isPaid;
  final PinTextDirection pinTextDirection;
  final String deskripsi;
  final int hargaTiket;
  final double rating;
  final String alamat;

  const WisataModel({
    required this.namaWisata,
    required this.wilayah,
    required this.status,
    required this.jamOperasional,
    required this.image,
    required this.pinPosition,
    required this.isPaid,
    required this.deskripsi,
    required this.hargaTiket,
    required this.rating,
    required this.alamat,
    this.pinTextDirection = PinTextDirection.right,
  });
}
