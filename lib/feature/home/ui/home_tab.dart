
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/core/utils/app_text_style.dart';
import 'package:e_commerce_app/core/utils/custom_cart_icon.dart';
import 'package:e_commerce_app/core/utils/custom_text_form_field.dart';
import 'package:e_commerce_app/feature/home/ui/controller/favorites_controller.dart';
import 'package:e_commerce_app/feature/home/ui/data/products_api_service.dart';
import 'package:e_commerce_app/feature/home/ui/models/products_model.dart';
import 'package:e_commerce_app/feature/home/ui/profile/ui/widget/home_banner.dart';
import 'package:e_commerce_app/feature/product_details/ui/product_details_screen.dart';
import 'package:e_commerce_app/feature/cart/ui/controller/cart_controller.dart';
import 'package:e_commerce_app/feature/cart/ui/cart_screen.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<List<ProductsModel>> productsFuture;

  final TextEditingController searchController =
      TextEditingController();

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    productsFuture = ProductsApiService().getProducts();
  }

  // Filter Products
  List<ProductsModel> filterProducts(
    List<ProductsModel> products,
  ) {
    if (searchQuery.trim().isEmpty) {
      return products;
    }

    return products.where((product) {
      return product.title.toLowerCase().contains(
            searchQuery.trim().toLowerCase(),
          );
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Search and Cart
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: searchController,
                    hintText: "what do you search for?",
                    prefixIcon: Icons.search,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Cart Icon
                AnimatedBuilder(
                  animation: CartController.instance,
                  builder: (context, child) {
                    final count = CartController.instance.totalCount;

                    return CustomCartIcon(
                      count: count,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Banner
            const HomeBanner(),

            const SizedBox(height: 24),

            // Categories Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: AppTextStyle.style18500White.copyWith(
                    color: AppColor.mainColor,
                  ),
                ),
                Text(
                  "view all",
                  style: AppTextStyle.style18400White.copyWith(
                    color: AppColor.mainColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Categories Grid
            FutureBuilder<List<ProductsModel>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Text(
                    "Failed to load categories",
                    style: TextStyle(color: colors.onSurface),
                  );
                }

                final categoryProducts = <String, ProductsModel>{};

                for (final product in snapshot.data ?? []) {
                  categoryProducts.putIfAbsent(
                    product.category,
                    () => product,
                  );
                }

                final categories =
                    categoryProducts.entries.take(4).toList();

                return SizedBox(
                  height: 120,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return Column(
                        children: [
                          Expanded(
                            child: ClipOval(
                              child: Container(
                                width: double.infinity,
                                color: colors.surfaceContainerHighest,
                                child: Image.network(
                                  category.value.thumbnail,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Icon(
                                      Icons.image_not_supported_outlined,
                                      color: colors.onSurfaceVariant,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            category.key,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.onSurface,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Products Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  searchQuery.isEmpty ? "Products" : "Search Results",
                  style: AppTextStyle.style18500White.copyWith(
                    color: AppColor.mainColor,
                  ),
                ),

                Text(
                  "view all",
                  style: AppTextStyle.style18400White.copyWith(
                    color: AppColor.mainColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Products From API
            FutureBuilder<List<ProductsModel>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 40,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Something went wrong!",
                          style: TextStyle(color: colors.onSurface),
                        ),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              productsFuture =
                                  ProductsApiService().getProducts();
                            });
                          },
                          child: const Text("Try Again"),
                        ),
                      ],
                    ),
                  );
                }

                final products = snapshot.data ?? [];

                final filteredProducts = filterProducts(products);

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 55,
                            color: colors.onSurfaceVariant,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            "No products found",
                            style: TextStyle(
                              fontSize: 16,
                              color: colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredProducts.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.55,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return ProductCard(
                      product: product,
                      name: product.title,
                      price: product.price,
                      rating: product.rating,
                      imageUrl: product.thumbnail,
                      discountPercentage: product.discountPercentage,

                      // Open Product Details
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(product: product),
                          ),
                        );
                      },

                      // Add To Cart
                      onAddToCart: () {
                        final cart = CartController.instance;

                        cart.addProduct(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product added to cart'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Product Card Widget

class ProductCard extends StatefulWidget {
  final ProductsModel product;
  final String name;
  final double price;
  final double rating;
  final String imageUrl;
  final double discountPercentage;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.discountPercentage,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final oldPrice =
        widget.price / (1 - widget.discountPercentage / 100);

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.broken_image,
                            size: 50,
                            color: colors.onSurfaceVariant,
                          );
                        },
                      ),
                    ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 5,
                    right: 5,
                    child: AnimatedBuilder(
                      animation: FavoritesController.instance,
                      builder: (context, child) {
                        final isFavorite =
                            FavoritesController.instance.isFavorite(
                          widget.product,
                        );

                        return IconButton(
                          onPressed: () {
                            FavoritesController.instance.toggleFavorite(
                              widget.product,
                            );
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),

                  // Discount
                  Positioned(
                    top: 10,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${widget.discountPercentage.toStringAsFixed(0)}% OFF",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          widget.rating.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "${widget.price.toStringAsFixed(0)} EGP",
                      style: const TextStyle(
                        color: AppColor.mainColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "${oldPrice.toStringAsFixed(0)} EGP",
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 10,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                    const Spacer(),

                    // Add To Cart
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: widget.onAddToCart,
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 18,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColor.mainColor,
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
  }
}
