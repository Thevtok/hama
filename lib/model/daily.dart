
class Daily {
  final String? name;
  final String? noOrder;
  final String? lokasi;
  final String? jenisTreatment;
  final String? hamaDitemukan;
  final int? jumlah;
  final String? tanggal;
  dynamic  buktiFoto;
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
     this.keterangan,
  });

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
     
      'keterangan': keterangan,
    };
  }
}
