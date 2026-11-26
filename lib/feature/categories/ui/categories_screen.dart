
import 'package:e_commerce_app/feature/categories/ui/category_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/feature/home/ui/data/products_api_service.dart';
import 'package:e_commerce_app/feature/home/ui/models/products_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<ProductsModel>> productsFuture;

  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  @override
  void initState() {
    super.initState();
    productsFuture = ProductsApiService().getProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: colors.onSurface,
        elevation: 0,
      ),

      body: FutureBuilder<List<ProductsModel>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load categories',
                    style: TextStyle(color: colors.onSurface),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        productsFuture =
                            ProductsApiService().getProducts();
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data ?? [];

          // Get unique categories
          final Map<String, ProductsModel> categoriesMap = {};

          for (final product in products) {
            categoriesMap.putIfAbsent(
              product.category,
              () => product,
            );
          }

          final categories = categoriesMap.entries.where((entry) {
            return entry.key
                .toLowerCase()
                .contains(searchText.toLowerCase());
          }).toList();

          return Column(
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: colors.onSurface),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    hintStyle: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: colors.onSurfaceVariant,
                    ),
                    suffixIcon: searchText.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                searchText = '';
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: colors.onSurfaceVariant,
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: colors.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Categories Grid
              Expanded(
                child: categories.isEmpty
                    ? Center(
                        child: Text(
                          'No categories found',
                          style: TextStyle(color: colors.onSurface),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.95,
                        ),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final categoryName = category.key;

                          final categoryProducts = products
                              .where(
                                (product) =>
                                    product.category == categoryName,
                              )
                              .toList();

                          return InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryProductsScreen(
                                    categoryName: categoryName,
                                    products: categoryProducts,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colors.outlineVariant,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.shadow.withValues(
                                      alpha: 0.08,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Category Image
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius:
                                          const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        color: colors.surfaceContainerHighest,
                                        padding: const EdgeInsets.all(12),
                                        child: Image.network(
                                          category.value.thumbnail,
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                              color: colors.onSurfaceVariant,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Category Name and Products Count
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      8,
                                      6,
                                      8,
                                      10,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          categoryName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: colors.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${categoryProducts.length} Products',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colors.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
