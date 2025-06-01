import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  CartService(this.userId);

  // Add product to cart with increment if exists
  Future<void> addProduct(Map<String, dynamic> product) async {
    final docRef = _db
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(product['name'] as String);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final currentQty = (data?['quantity'] as int?) ?? 1;
      await docRef.update({'quantity': currentQty + 1});
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
  }

  // Increment product quantity
  Future<void> incrementQuantity(String productName) async {
    final docRef = _db
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(productName);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final currentQty = (data?['quantity'] as int?) ?? 1;
      await docRef.update({'quantity': currentQty + 1});
    }
  }

  // Get all cart items once as a list
  Future<List<Map<String, dynamic>>> get cartItems async {
    final snapshot =
        await _db.collection('carts').doc(userId).collection('items').get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Decrement product quantity or remove if quantity <= 1
  Future<void> decrementQuantity(String productName) async {
    final docRef = _db
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(productName);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final currentQty = (data?['quantity'] as int?) ?? 1;

      if (currentQty > 1) {
        await docRef.update({'quantity': currentQty - 1});
      } else {
        await docRef.delete();
      }
    }
  }

  // Remove product from cart
  Future<void> removeFromCart(String productName) async {
    await _db
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(productName)
        .delete();
  }

  // Stream cart items for real-time updates
  Stream<QuerySnapshot<Map<String, dynamic>>> cartStream() {
    return _db.collection('carts').doc(userId).collection('items').snapshots();
  }

  // Calculate total price of cart items
  Future<double> getTotalPrice() async {
    final items = await cartItems;
    double total = 0.0;

    for (final item in items) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = item['quantity'] as int? ?? 1;
      total += price * quantity;
    }

    return total;
  }
}
