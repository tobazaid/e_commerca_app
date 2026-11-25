
import 'package:e_commerce_app/feature/cart/ui/model/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/feature/home/ui/models/products_model.dart';

class CartController extends ChangeNotifier {
  CartController._();

  static final CartController instance = CartController._();

  final List<CartItemModel> items = [];

  void addProduct(ProductsModel product) {
    final index = items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index != -1) {
      items[index].quantity++;
    } else {
      items.add(CartItemModel(product: product));
    }

    notifyListeners();
  }

  void increaseQuantity(CartItemModel item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItemModel item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    }
  }

  void removeProduct(CartItemModel item) {
    items.remove(item);
    notifyListeners();
  }

  int get totalCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return items.fold(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );
  }

  // Clear Cart
  void clearCart() {
    items.clear();
    notifyListeners();
  }
}
