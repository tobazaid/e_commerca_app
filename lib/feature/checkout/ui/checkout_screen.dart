
import 'package:flutter/material.dart';
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/feature/cart/ui/controller/cart_controller.dart';
import 'package:e_commerce_app/feature/addresses/ui/data/address_service.dart';
import 'package:e_commerce_app/feature/addresses/ui/model/address_model.dart';
import 'package:e_commerce_app/feature/addresses/ui/address_screen.dart';
import 'package:e_commerce_app/feature/orders/ui/data/orders_service.dart';
import 'package:e_commerce_app/feature/orders/ui/model/order_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final AddressesService addressesService = AddressesService();
  final OrdersService ordersService = OrdersService();

  List<AddressModel> addresses = [];
  String? selectedAddressId;

  String paymentMethod = 'Cash on Delivery';

  bool isLoadingAddresses = true;
  bool isCheckingOut = false;
  String? addressError;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    try {
      final result = await addressesService.getAddresses();

      if (!mounted) return;

      setState(() {
        addresses = result;

        if (addresses.isNotEmpty) {
          final defaultAddress = addresses.where(
            (address) => address.isDefault,
          );

          selectedAddressId = defaultAddress.isNotEmpty
              ? defaultAddress.first.id
              : addresses.first.id;
        }

        isLoadingAddresses = false;
        addressError = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingAddresses = false;
        addressError = e.toString();
      });
    }
  }

  String get selectedAddressText {
    final address = addresses.firstWhere(
      (address) => address.id == selectedAddressId,
    );

    return '${address.fullName}, '
        '${address.phone}, '
        '${address.city}, '
        '${address.street}, '
        'Building ${address.building}, '
        'Apartment ${address.apartment}';
  }

  Future<void> openAddresses() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddressScreen(),
      ),
    );

    if (!mounted) return;

    setState(() {
      isLoadingAddresses = true;
    });

    await loadAddresses();
  }

  Future<void> confirmOrder() async {
    final cart = CartController.instance;

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
        ),
      );
      return;
    }

    if (selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery address'),
        ),
      );
      return;
    }

    if (isCheckingOut) return;

    setState(() {
      isCheckingOut = true;
    });

    try {
      final orderId = DateTime.now()
          .microsecondsSinceEpoch
          .toString();

      final products = cart.items.map((item) {
        return {
          'productId': item.product.id,
          'title': item.product.title,
          'thumbnail': item.product.thumbnail,
          'price': item.product.price,
          'quantity': item.quantity,
          'subtotal': item.product.price * item.quantity,
        };
      }).toList();

      final order = OrderModel(
        id: orderId,
        products: products,
        totalPrice: cart.totalPrice,
        createdAt: DateTime.now(),
        shippingAddress: selectedAddressText,
        paymentMethod: paymentMethod,
      );

      await ordersService.saveOrder(order);

      cart.clearCart();

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 55,
            ),
            title: const Text('Order Confirmed'),
            content: const Text(
              'Your order has been placed successfully!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Continue'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isCheckingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cart = CartController.instance;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColor.mainColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Delivery Address
                _sectionTitle('Delivery Address', colors),

                const SizedBox(height: 10),

                if (isLoadingAddresses)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (addressError != null)
                  Column(
                    children: [
                      Text(
                        'Failed to load addresses',
                        style: TextStyle(color: colors.error),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLoadingAddresses = true;
                          });
                          loadAddresses();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  )
                else if (addresses.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.outlineVariant,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.location_off_outlined,
                          size: 35,
                        ),
                        const SizedBox(height: 8),
                        const Text('No saved addresses'),
                        TextButton(
                          onPressed: openAddresses,
                          child: const Text('Add an Address'),
                        ),
                      ],
                    ),
                  )
                else
                  ...addresses.map((address) {
                    return Card(
                      color: colors.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selectedAddressId == address.id
                              ? AppColor.mainColor
                              : colors.outlineVariant,
                        ),
                      ),
                      child: RadioListTile<String>(
                        value: address.id,
                        groupValue: selectedAddressId,
                        activeColor: AppColor.mainColor,
                        onChanged: (value) {
                          setState(() {
                            selectedAddressId = value;
                          });
                        },
                        title: Text(
                          address.fullName,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${address.phone}\n'
                          '${address.city}, ${address.street}\n'
                          'Building ${address.building}, '
                          'Apartment ${address.apartment}',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        secondary: Icon(
                          Icons.location_on_outlined,
                          color: AppColor.mainColor,
                        ),
                      ),
                    );
                  }),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: openAddresses,
                    icon: const Icon(Icons.edit_location_alt_outlined),
                    label: const Text('Manage Addresses'),
                  ),
                ),

                const SizedBox(height: 20),

                // Payment Method
                _sectionTitle('Payment Method', colors),

                const SizedBox(height: 10),

                Card(
                  color: colors.surface,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colors.outlineVariant,
                    ),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'Cash on Delivery',
                        groupValue: paymentMethod,
                        activeColor: AppColor.mainColor,
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value!;
                          });
                        },
                        title: Text(
                          'Cash on Delivery',
                          style: TextStyle(color: colors.onSurface),
                        ),
                        secondary: const Icon(
                          Icons.money,
                          color: AppColor.mainColor,
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: colors.outlineVariant,
                      ),
                      RadioListTile<String>(
                        value: 'Credit/Debit Card',
                        groupValue: paymentMethod,
                        activeColor: AppColor.mainColor,
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value!;
                          });
                        },
                        title: Text(
                          'Credit / Debit Card',
                          style: TextStyle(color: colors.onSurface),
                        ),
                        secondary: const Icon(
                          Icons.credit_card,
                          color: AppColor.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Order Summary
                _sectionTitle('Order Summary', colors),

                const SizedBox(height: 10),

                ...cart.items.map((item) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.product.thumbnail,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      item.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colors.onSurface),
                    ),
                    subtitle: Text(
                      'Quantity: ${item.quantity}',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    trailing: Text(
                      '${(item.product.price * item.quantity).toStringAsFixed(2)} EGP',
                      style: const TextStyle(
                        color: AppColor.mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Total and Confirm Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${cart.totalPrice.toStringAsFixed(2)} EGP',
                      style: const TextStyle(
                        color: AppColor.mainColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isCheckingOut ||
                            isLoadingAddresses ||
                            addresses.isEmpty ||
                            selectedAddressId == null
                        ? null
                        : confirmOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.mainColor,
                      foregroundColor: Colors.white,
                    ),
                    child: isCheckingOut
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Confirm Order'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
    String title,
    ColorScheme colors,
  ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colors.onSurface,
      ),
    );
  }
}
