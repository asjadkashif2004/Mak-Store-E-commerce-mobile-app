import 'package:flutter/material.dart';
import 'cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.cartService});

  final CartService cartService;

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.cartService.cartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final cartItems = snapshot.data ?? [];

          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];

              return ListTile(
                leading:
                    item['image'] != null
                        ? Image.network(
                          item['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.image_not_supported),
                title: Text(item['name']),
                subtitle: Text(
                  'Price: \$${(item['price'] ?? 0).toStringAsFixed(2)}',
                ),
                trailing: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () async {
                          await widget.cartService.decrementQuantity(
                            item['name'],
                          );
                          setState(() {});
                        },
                      ),
                      Text('${item['quantity']}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await widget.cartService.incrementQuantity(
                            item['name'],
                          );
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await widget.cartService.removeFromCart(item['name']);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<double>(
        future: widget.cartService.getTotalPrice(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Calculating total...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final total = snapshot.data ?? 0.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
