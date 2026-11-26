
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_app/feature/addresses/ui/model/address_model.dart';

class AddressesService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get current user's addresses collection
  CollectionReference<Map<String, dynamic>> get addressesCollection {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('addresses');
  }

  // Add Address
  Future<void> addAddress(AddressModel address) async {
    final doc = addressesCollection.doc();

    final newAddress = AddressModel(
      id: doc.id,
      fullName: address.fullName,
      phone: address.phone,
      city: address.city,
      street: address.street,
      building: address.building,
      apartment: address.apartment,
      isDefault: address.isDefault,
    );

    await doc.set(newAddress.toMap());
  }

  // Get Addresses
  Future<List<AddressModel>> getAddresses() async {
    final snapshot = await addressesCollection.get();

    return snapshot.docs.map((doc) {
      return AddressModel.fromMap(
        doc.id,
        doc.data(),
      );
    }).toList();
  }

  // Update Address
  Future<void> updateAddress(AddressModel address) async {
    await addressesCollection
        .doc(address.id)
        .update(address.toMap());
  }

  // Delete Address
  Future<void> deleteAddress(String addressId) async {
    await addressesCollection
        .doc(addressId)
        .delete();
  }
}
