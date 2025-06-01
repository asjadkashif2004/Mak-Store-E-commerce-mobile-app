import 'package:flutter/material.dart';

class ElectronicsProductsPage extends StatelessWidget {
  const ElectronicsProductsPage({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Wireless Headphones',
      'price': 59.99,
      'description':
          'High-quality wireless headphones with noise cancellation.',
      'image': 'assets/images/headphones.png',
    },
    {
      'name': 'Smartwatch',
      'price': 120.00,
      'description': 'Stylish smartwatch with health and fitness tracking.',
      'image': 'assets/images/smartwatch.png',
    },
    {
      'name': 'Bluetooth Speaker',
      'price': 40.00,
      'description': 'Portable Bluetooth speaker with deep bass sound.',
      'image': 'assets/images/speaker.png',
    },
  ];

  Future<void> showProductDetails(
    BuildContext context,
    Map<String, dynamic> product,
  ) async {
    return showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(product['name'] ?? ''),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(product['image'] ?? '', height: 100),
                const SizedBox(height: 10),
                Text(product['description'] ?? ''),
                const SizedBox(height: 10),
                Text(
                  'Price: \$${(product['price'] ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
      appBar: AppBar(
        title: const Text('Electronics & Tech Products'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: ListTile(
              leading: Image.asset(
                product['image'] ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
              title: Text(product['name'] ?? ''),
              subtitle: Text('\$${(product['price'] ?? 0).toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
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
