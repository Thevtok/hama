class PerhitunganIndex {
  final String name;
  final String noOrder;
  final String lokasi;
  final String jenisHama;
  final int indeksPopulasi;
  final int jumlah;
  final String tanggal;
  final String status;

  PerhitunganIndex({
    required this.name,
    required this.noOrder,
    required this.lokasi,
    required this.jenisHama,
    required this.indeksPopulasi,
    required this.jumlah,
    required this.tanggal,
    required this.status,
  });

  factory PerhitunganIndex.fromJson(Map<String, dynamic> json) {
    return PerhitunganIndex(
      name: json['name'],
      noOrder: json['no_order'],
      lokasi: json['lokasi'],
      jenisHama: json['jenis_hama'],
      indeksPopulasi: json['indeks_populasi'],
      jumlah: json['jumlah'],
      tanggal: json['tanggal'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'no_order': noOrder,
      'lokasi': lokasi,
      'jenis_hama': jenisHama,
      'indeks_populasi': indeksPopulasi,
      'jumlah': jumlah,
      'tanggal': tanggal,
      'status': status,
    };
  }
}
