class Pemakaian {
  final String name;
  final String noOrder;
  final String satuan;
  final String satuanb;
  final int ins;
  final int out;
  final int stokAkhir;
  final int stokAwal;
  final String merk;
  final String tanggal;
  final String bahanAktif;

  Pemakaian({
    required this.name,
    required this.noOrder,
    required this.satuan,
    required this.satuanb,
    required this.ins,
    required this.out,
    required this.stokAkhir,
    required this.stokAwal,
    required this.merk,
    required this.tanggal,
    required this.bahanAktif,
  });

  factory Pemakaian.fromJson(Map<String, dynamic> json) {
    return Pemakaian(
      name: json['name'],
      noOrder: json['no_order'],
      satuan: json['satuan'],
      satuanb: json['satuanb'],
      ins: json['ins'],
      out: json['out'],
      stokAkhir: json['stok_akhir'],
      stokAwal: json['stok_awal'],
      merk: json['merk'],
      tanggal: json['tanggal'],
      bahanAktif: json['bahan_aktif'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'no_order': noOrder,
      'satuan': satuan,
      'satuanb': satuanb,
      'ins': ins,
      'out': out,
      'stok_akhir': stokAkhir,
      'stok_awal': stokAwal,
      'merk': merk,
      'tanggal': tanggal,
      'bahan_aktif': bahanAktif,
    };
  }
}
