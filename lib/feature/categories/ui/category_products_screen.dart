
import 'package:e_commerce_app/feature/home/ui/controller/favorites_controller.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/feature/home/ui/models/products_model.dart';
import 'package:e_commerce_app/feature/cart/ui/controller/cart_controller.dart';
import 'package:e_commerce_app/feature/product_details/ui/product_details_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  final List<ProductsModel> products;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(
            color: Color(0xFF003B73),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: products.isEmpty
          ? const Center(
              child: Text('No products found'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.50,
              ),
              itemBuilder: (context, index) {
                final product = products[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Image.network(
                                    product.thumbnail,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Favorite Button
                              Positioned(
                                top: 2,
                                right: 2,
                                child: AnimatedBuilder(
                                  animation:
                                      FavoritesController.instance,
                                  builder: (context, child) {
                                    final isFavorite =
                                        FavoritesController.instance
                                            .isFavorite(product);

                                    return IconButton(
                                      onPressed: () {
                                        FavoritesController.instance
                                            .toggleFavorite(product);
                                      },
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF003B73),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      product.rating.toString(),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${product.price.toStringAsFixed(2)} EGP',
                                  style: TextStyle(
                                    color: AppColor.mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),

                                // Add To Cart
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () {
                                      CartController.instance
                                          .addProduct(product);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Product added to cart',
                                          ),
                                          duration:
                                              Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor:
                                          AppColor.mainColor,
                                      shape: const CircleBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
