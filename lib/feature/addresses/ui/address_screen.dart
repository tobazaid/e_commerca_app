
import 'package:flutter/material.dart';
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/feature/addresses/ui/add_address_screen.dart';
import 'package:e_commerce_app/feature/addresses/ui/data/address_service.dart';
import 'package:e_commerce_app/feature/addresses/ui/model/address_model.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final AddressesService addressesService = AddressesService();

  late Future<List<AddressModel>> addressesFuture;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  void loadAddresses() {
    addressesFuture = addressesService.getAddresses();
  }

  Future<void> openAddAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddAddressScreen(),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(loadAddresses);
    }
  }

  Future<void> openEditAddress(AddressModel address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddAddressScreen(address: address),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(loadAddresses);
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await addressesService.deleteAddress(id);

      if (!mounted) return;

      setState(loadAddresses);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address deleted successfully')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: AppColor.mainColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddAddress,
        backgroundColor: AppColor.mainColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<AddressModel>>(
        future: addressesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: colors.onSurface),
              ),
            );
          }

          final addresses = snapshot.data ?? [];

          if (addresses.isEmpty) {
            return Center(
              child: Text(
                'No addresses added yet',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colors.outlineVariant,
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: colors.onSurfaceVariant,
                  ),
                  title: Text(
                    address.fullName,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${address.city}, ${address.street}\n'
                    'Building: ${address.building} - '
                    'Apartment: ${address.apartment}\n'
                    'Phone: ${address.phone}',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    iconColor: colors.onSurfaceVariant,
                    onSelected: (value) {
                      if (value == 'edit') {
                        openEditAddress(address);
                      } else if (value == 'delete') {
                        deleteAddress(address.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
