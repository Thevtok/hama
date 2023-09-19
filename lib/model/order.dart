class Order {
  final int? id; // Properti id menjadi nullable
  final String noOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    this.id, // Buat properti id menjadi opsional
    required this.noOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'], // Tetap ambil nilai id dari JSON jika ada
      noOrder: json['no_order'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_order': noOrder,
    
    };
  }
}
