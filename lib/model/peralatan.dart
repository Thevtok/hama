class MonitoringPeralatan {
  final String name;
  final String noOrder;
  final String merek;
  final int jumlah;
  final String satuan;
  final String kondisi;
  final String tanggal;

  MonitoringPeralatan({
    required this.name,
    required this.noOrder,
    required this.merek,
    required this.jumlah,
    required this.satuan,
    required this.kondisi,
    required this.tanggal,
  });

  factory MonitoringPeralatan.fromJson(Map<String, dynamic> json) {
    return MonitoringPeralatan(
      name: json['name'],
      noOrder: json['no_order'],
      merek: json['merek'],
      jumlah: json['jumlah'],
      satuan: json['satuan'],
      kondisi: json['kondisi'],
      tanggal: json['tanggal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'no_order': noOrder,
      'merek': merek,
      'jumlah': jumlah,
      'satuan': satuan,
      'kondisi': kondisi,
      'tanggal': tanggal,
    };
  }
}
