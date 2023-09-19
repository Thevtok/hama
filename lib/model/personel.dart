class Personel {
  final int id;
  final String name;

  final String noOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Personel({
    required this.id,
    required this.name,
    required this.noOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Personel.fromJson(Map<String, dynamic> json) {
    return Personel(
      id: json['id'],
      name: json['name'],
      noOrder: json['no_order'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'no_order': noOrder,
    };
  }
}

class Absen {
  final int id;
  final String name;
  final String? tanggal;
  final String? keterangan;

  final String noOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Absen({
    required this.id,
    required this.name,
    this.tanggal,
    this.keterangan,
    required this.noOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Absen.fromJson(Map<String, dynamic> json) {
    return Absen(
      id: json['id'],
      name: json['name'],
      noOrder: json['no_order'],
      tanggal: json['tanggal'],
      keterangan: json['keterangan'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'no_order': noOrder,
    };
  }
}
