import 'dart:convert';
import 'dart:io';

class Inpeksi {
  final String? name;
  final String? noOrder;
  final String? lokasi;

  final String? tanggal;
  dynamic buktiFoto;
  final String? buktiFotoPath;
  final String? keterangan;
  final String? rekomendasi;

  Inpeksi({
    this.name,
    this.noOrder,
    this.lokasi,
    this.rekomendasi,
    this.tanggal,
    this.buktiFoto,
    this.buktiFotoPath,
    this.keterangan,
  });

  factory Inpeksi.fromJson(Map<String, dynamic> json) {
    return Inpeksi(
      name: json['name'],
      noOrder: json['no_order'],
      lokasi: json['lokasi'],
      rekomendasi: json['rekomendasi'],
      tanggal: json['tanggal'],
      buktiFoto: json['bukti_foto'],
      buktiFotoPath: json['bukti_foto_path'],
      keterangan: json['keterangan'],
    );
  }
  static String imageToBase64(String imagePath) {
    List<int> imageBytes = File(imagePath).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  static File base64ToImage(String base64Image, String imagePath) {
    List<int> imageBytes = base64Decode(base64Image);
    File imageFile = File(imagePath);
    imageFile.writeAsBytesSync(imageBytes);
    return imageFile;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'no_order': noOrder,
      'lokasi': lokasi,
      'rekomendasi': rekomendasi,
      'tanggal': tanggal,
      'keterangan': keterangan,
      'bukti_foto_path': buktiFotoPath,
      'bukti_foto': buktiFoto,
    };
  }
}
