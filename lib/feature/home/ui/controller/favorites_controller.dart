
import 'package:flutter/material.dart';
import 'package:e_commerce_app/feature/home/ui/models/products_model.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController._();

  static final FavoritesController instance =
      FavoritesController._();

  final List<ProductsModel> items = [];

  bool isFavorite(ProductsModel product) {
    return items.any((item) => item.id == product.id);
  }

  void toggleFavorite(ProductsModel product) {
    if (isFavorite(product)) {
      items.removeWhere((item) => item.id == product.id);
    } else {
      items.add(product);
    }

    notifyListeners();
  }
}
