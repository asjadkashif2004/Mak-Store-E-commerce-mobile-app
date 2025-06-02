import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  CartService(this.userId);

  CollectionReference<Map<String, dynamic>> get _cartCollection =>
      _db.collection('carts').doc(userId).collection('items');

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _db.collection('orders');

  Future<void> addProduct(Map<String, dynamic> product) async {
    try {
      final docRef = _cartCollection.doc(product['name']);
      final doc = await docRef.get();

      if (doc.exists) {
        await incrementQuantity(product['name']);
      } else {
        await docRef.set({
          'name': product['name'],
          'price': (product['price'] as num).toDouble(),
          'image': product['image'],
          'description': product['description'],
          'quantity': 1,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> incrementQuantity(String productName) async {
    final docRef = _cartCollection.doc(productName);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data();
      final currentQty = (data?['quantity'] ?? 1) as int;
      await docRef.update({'quantity': currentQty + 1});
    }
  }

  Future<void> decrementQuantity(String productName) async {
    final docRef = _cartCollection.doc(productName);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data();
      final currentQty = (data?['quantity'] ?? 1) as int;

      if (currentQty > 1) {
        await docRef.update({'quantity': currentQty - 1});
      } else {
        await docRef.delete(); // Remove item if quantity is 1
      }
    }
  }

  Future<void> removeFromCart(String productName) async {
    await _cartCollection.doc(productName).delete();
  }

  Stream<List<Map<String, dynamic>>> cartStream() {
    return _cartCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'],
          'price': data['price'],
          'image': data['image'],
          'description': data['description'],
          'quantity': data['quantity'],
        };
      }).toList();
    });
  }

  Future<double> getTotalPrice() async {
    final snapshot = await _cartCollection.get();
    double total = 0.0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      total += (data['price'] ?? 0.0) * (data['quantity'] ?? 1);
    }
    return total;
  }

  Stream<double> totalPriceStream() {
    return _cartCollection.snapshots().map((snapshot) {
      double total = 0.0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        total += (data['price'] ?? 0.0) * (data['quantity'] ?? 1);
      }
      return total;
    });
  }

  /// 🔄 Get all current cart items
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final snapshot = await _cartCollection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// ✅ Clear the cart after order placement
  Future<void> clearCart() async {
    final snapshot = await _cartCollection.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// 🛒 Place order by saving cart contents to 'orders' collection
  Future<void> placeOrder() async {
    final cartItems = await getCartItems();
    final total = await getTotalPrice();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _ordersCollection.add({
      'userId': user.uid,
      'email': user.email,
      'items': cartItems,
      'total': total,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await clearCart();
  }
}
