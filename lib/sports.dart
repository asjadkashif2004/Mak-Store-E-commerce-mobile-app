import 'package:flutter/material.dart';

class SportsProductsPage extends StatelessWidget {
  const SportsProductsPage({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Football',
      'price': 25.99,
      'description': 'Official size and weight football for outdoor play.',
      'image': 'assets/images/football.png',
    },
    {
      'name': 'Running Shoes',
      'price': 79.99,
      'description': 'Lightweight running shoes with breathable fabric.',
      'image': 'assets/images/shoes.png',
    },
    {
      'name': 'Fitness Tracker',
      'price': 55.00,
      'description': 'Track your workouts and health with this fitness band.',
      'image': 'assets/images/fitness.png',
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
      backgroundColor: Colors.white, // Set background to white
      appBar: AppBar(
        title: const Text('Sports & Outdoors Products'),
        backgroundColor: Colors.green, // AppBar stays green
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
                icon: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.black,
                ), // Black icon
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
