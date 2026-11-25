
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/products_model.dart';

class ProductsApiService {
  Future<List<ProductsModel>> getProducts() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List productsJson = data['products'];

      return productsJson
          .map((product) => ProductsModel.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
