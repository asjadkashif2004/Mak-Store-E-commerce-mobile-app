import 'package:flutter/material.dart';

class MedicinesProductsPage extends StatelessWidget {
  const MedicinesProductsPage({super.key});

  Future<void> showProductDetails(
    BuildContext context,
    Map<String, dynamic> product,
  ) async {
    return showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              product['name'] ?? '',
              style: const TextStyle(color: Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(product['image'] ?? '', height: 100),
                const SizedBox(height: 10),
                Text(
                  product['description'] ?? '',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  'Price: \$${(product['price'] ?? 0).toStringAsFixed(2)}',
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
    final List<Map<String, dynamic>> products = [
      {
        'name': 'Panadol',
        'price': 2.00,
        'description': 'Effective pain relief for headaches and minor aches.',
        'image': 'assets/images/panadol.png',
      },
      {
        'name': 'Paracetamol',
        'price': 12.00,
        'description':
            'Pain reliever and fever reducer for adults and children.',
        'image': 'assets/images/paracetamol.jpeg',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Medicines & Health Products'),
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
                product['image'] ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
              title: Text(
                product['name'] ?? '',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                '\$${(product['price'] ?? 0).toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.black),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.black,
                ), // black cart icon
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
