class Inpeksi {
  final String? name;
  final String? noOrder;
  final String? lokasi;

  final String? tanggal;
  dynamic buktiFoto;
  final String? keterangan;
  final String? rekomendasi;

  Inpeksi({
    this.name,
    this.noOrder,
    this.lokasi,
    this.rekomendasi,
    this.tanggal,
    this.buktiFoto,
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
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'no_order': noOrder,
      'lokasi': lokasi,
      'rekomendasi': rekomendasi,
      'tanggal': tanggal,
      'keterangan': keterangan,
    };
  }
}
