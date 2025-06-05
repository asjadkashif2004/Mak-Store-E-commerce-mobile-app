import 'package:flutter/material.dart';

class KitchenProductsPage extends StatelessWidget {
  const KitchenProductsPage({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Blender',
      'price': 35.00,
      'description': 'High-speed blender perfect for smoothies and shakes.',
      'image': 'assets/images/blender.png',
    },
    {
      'name': 'Cookware Set',
      'price': 80.00,
      'description': 'Non-stick cookware set with 5 essential pieces.',
      'image': 'assets/images/cookware.png',
    },
    {
      'name': 'Coffee Maker',
      'price': 45.50,
      'description': 'Automatic coffee maker with programmable timer.',
      'image': 'assets/images/coffee.png',
    },
  ];

  void showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              product['name'],
              style: const TextStyle(color: Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(product['image'], height: 100),
                const SizedBox(height: 10),
                Text(
                  product['description'],
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  'Price: \$${product['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product['name']} added to cart!'),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to Cart'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home & Kitchen'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            color: Colors.green[100], // Soft green background
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: ListTile(
              leading: Image.asset(
                product['image'],
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
              title: Text(
                product['name'],
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                '\$${product['price'].toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.black),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: Colors.black),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product['name']} added to cart!'),
                    ),
                  );
                },
              ),
              onTap: () => showProductDetails(context, product),
            ),
          );
        },
      ),
    );
  }
}
