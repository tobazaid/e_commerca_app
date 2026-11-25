
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_app/feature/orders/ui/model/order_model.dart';

class OrdersService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  // Save Order
  Future<void> saveOrder(OrderModel order) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(order.id)
        .set(order.toMap());
  }

  // Get User Orders
  Future<List<OrderModel>> getOrders() async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return OrderModel.fromMap(
        doc.id,
        doc.data(),
      );
    }).toList();
  }
}
