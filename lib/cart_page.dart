import 'package:flutter/material.dart';
import 'cart_service.dart';

class CartPage extends StatelessWidget {
  final CartService cartService;

  const CartPage({super.key, required this.cartService});

  void _checkout(BuildContext context) async {
    try {
      await cartService.placeOrder();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Checkout failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: cartService.cartStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text("Your cart is empty."));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading:
                      item['image'] != null && item['image'].isNotEmpty
                          ? Image.network(
                            item['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                          )
                          : const Icon(Icons.image_not_supported, size: 50),
                  title: Text(item['name']),
                  subtitle: Text("₹${item['price']} x ${item['quantity']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        tooltip: 'Decrease quantity',
                        onPressed:
                            () => cartService.decrementQuantity(item['name']),
                      ),
                      Text("${item['quantity']}"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Increase quantity',
                        onPressed:
                            () => cartService.incrementQuantity(item['name']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Remove from cart',
                        onPressed:
                            () => cartService.removeFromCart(item['name']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: StreamBuilder<double>(
        stream: cartService.totalPriceStream(),
        initialData: 0.0,
        builder: (context, snapshot) {
          final total = snapshot.data?.toStringAsFixed(2) ?? "0.00";
          return Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ₹$total",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () => _checkout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Checkout"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
