
class OrderModel {
  final String id;
  final List<Map<String, dynamic>> products;
  final double totalPrice;
  final DateTime createdAt;
  final String status;

  OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.createdAt,
    this.status = 'Pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'products': products,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory OrderModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return OrderModel(
      id: id,
      products: List<Map<String, dynamic>>.from(
        map['products'] ?? [],
      ),
      totalPrice: (map['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
      status: map['status'] ?? 'Pending',
    );
  }
}
