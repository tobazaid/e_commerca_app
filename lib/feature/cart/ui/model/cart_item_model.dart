import 'package:e_commerce_app/feature/home/ui/models/products_model.dart';

class CartItemModel {
  final ProductsModel product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });
}