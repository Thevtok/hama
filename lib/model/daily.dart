import 'dart:convert';
import 'dart:io';

class Daily {
  final String? name;
  final String? noOrder;
  final String? lokasi;
  final String? jenisTreatment;
  final String? hamaDitemukan;
  final int? jumlah;
  final String? tanggal;
  dynamic buktiFoto;
  final String? buktiFotoPath;
  final String? keterangan;

  Daily({
    this.name,
    this.noOrder,
    this.lokasi,
    this.jenisTreatment,
    this.hamaDitemukan,
    this.jumlah,
    this.tanggal,
    this.buktiFoto,
    this.buktiFotoPath,
    this.keterangan,
  });
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

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      name: json['name'],
      noOrder: json['no_order'],
      lokasi: json['lokasi'],
      jenisTreatment: json['jenis_treatment'],
      hamaDitemukan: json['hama_ditemukan'],
      jumlah: json['jumlah'],
      tanggal: json['tanggal'],
      buktiFoto: json['bukti_foto'],
      buktiFotoPath: json['bukti_foto_path'],
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'no_order': noOrder,
      'lokasi': lokasi,
      'jenis_treatment': jenisTreatment,
      'hama_ditemukan': hamaDitemukan,
      'jumlah': jumlah,
      'tanggal': tanggal,
      'bukti_foto': buktiFoto,
      'bukti_foto_path': buktiFotoPath,
      'keterangan': keterangan,
    };
  }
}
