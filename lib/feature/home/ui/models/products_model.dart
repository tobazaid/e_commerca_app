
class ProductsModel {
  final int id;
  final String title;
  final double price;
  final double rating;
  final String thumbnail;
  final String description;
  final double discountPercentage;
  final String category;

  ProductsModel({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.description,
    required this.discountPercentage,
    required this.category,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      description: json['description'],
      discountPercentage:
          (json['discountPercentage'] as num).toDouble(),
      category: json['category'] as String,
    );
  }
}
