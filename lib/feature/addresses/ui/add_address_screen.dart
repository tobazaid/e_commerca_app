
import 'package:e_commerce_app/feature/addresses/ui/data/address_service.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/core/utils/app_color.dart';
import 'package:e_commerce_app/feature/addresses/ui/model/address_model.dart';

class AddAddressScreen extends StatefulWidget {
  final AddressModel? address;

  const AddAddressScreen({
    super.key,
    this.address,
  });

  @override
  State<AddAddressScreen> createState() =>
      _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final AddressesService addressesService = AddressesService();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController cityController;
  late final TextEditingController streetController;
  late final TextEditingController buildingController;
  late final TextEditingController apartmentController;

  bool isDefault = false;
  bool isLoading = false;

  bool get isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();

    final address = widget.address;

    nameController = TextEditingController(
      text: address?.fullName ?? '',
    );

    phoneController = TextEditingController(
      text: address?.phone ?? '',
    );

    cityController = TextEditingController(
      text: address?.city ?? '',
    );

    streetController = TextEditingController(
      text: address?.street ?? '',
    );

    buildingController = TextEditingController(
      text: address?.building ?? '',
    );

    apartmentController = TextEditingController(
      text: address?.apartment ?? '',
    );

    isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    streetController.dispose();
    buildingController.dispose();
    apartmentController.dispose();

    super.dispose();
  }

  String? validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  Future<void> saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final address = AddressModel(
      id: widget.address?.id ?? '',
      fullName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      city: cityController.text.trim(),
      street: streetController.text.trim(),
      building: buildingController.text.trim(),
      apartment: apartmentController.text.trim(),
      isDefault: isDefault,
    );

    try {
      if (isEditing) {
        await addressesService.updateAddress(address);
      } else {
        await addressesService.addAddress(address);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Address updated successfully'
                : 'Address added successfully',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color textColor,
    required Color hintColor,
    required Color borderColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validateField,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(
            icon,
            color: AppColor.mainColor,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColor.mainColor,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Address' : 'Add Address',
        ),
        backgroundColor: AppColor.mainColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),

              const SizedBox(height: 20),

              buildTextField(
                label: 'Full Name',
                controller: nameController,
                icon: Icons.person_outline,
                textColor: colors.onSurface,
                hintColor: colors.onSurfaceVariant,
                borderColor: colors.outlineVariant,
              ),

              buildTextField(
                label: 'Phone Number',
                controller: phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textColor: colors.onSurface,
                hintColor: colors.onSurfaceVariant,
                borderColor: colors.outlineVariant,
              ),

              buildTextField(
                label: 'City',
                controller: cityController,
                icon: Icons.location_city_outlined,
                textColor: colors.onSurface,
                hintColor: colors.onSurfaceVariant,
                borderColor: colors.outlineVariant,
              ),

              buildTextField(
                label: 'Street',
                controller: streetController,
                icon: Icons.streetview,
                textColor: colors.onSurface,
                hintColor: colors.onSurfaceVariant,
                borderColor: colors.outlineVariant,
              ),

              buildTextField(
                label: 'Building Number',
                controller: buildingController,
                icon: Icons.business_outlined,
                textColor: colors.onSurface,
                hintColor: colors.onSurfaceVariant,
                borderColor: colors.outlineVariant,
              ),

              buildTextField(
                label: 'Apartment Number',
                controller: apartmentController,
                icon: Icons.home_outlined,
                textColor: colors.onSurface,
                hintColor: colors.onSurfaceVariant,
                borderColor: colors.outlineVariant,
              ),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: isDefault,
                activeColor: AppColor.mainColor,
                title: Text(
                  'Set as default address',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colors.onSurface,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    isDefault = value ?? false;
                  });
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          isEditing
                              ? 'Update Address'
                              : 'Save Address',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
