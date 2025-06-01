import 'package:flutter/material.dart';

class BooksProductsPage extends StatelessWidget {
  const BooksProductsPage({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Flutter Development',
      'price': 19.99,
      'description': 'Learn Flutter and Dart to build beautiful mobile apps.',
      'image': 'assets/images/flutter_book.png',
    },
    {
      'name': 'Data Science Essentials',
      'price': 25.00,
      'description': 'An introductory guide to data science concepts.',
      'image': 'assets/images/data_science.png',
    },
    {
      'name': 'Mystery Novel',
      'price': 12.50,
      'description': 'A thrilling mystery novel with unexpected twists.',
      'image': 'assets/images/novel.png',
    },
  ];

  void showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(product['name']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(product['image'], height: 100),
                const SizedBox(height: 10),
                Text(product['description']),
                const SizedBox(height: 10),
                Text(
                  'Price: \$${product['price'].toStringAsFixed(2)}',
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
      appBar: AppBar(title: const Text('Books'), backgroundColor: Colors.green),
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
                product['image'],
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
              title: Text(product['name']),
              subtitle: Text('\$${product['price'].toStringAsFixed(2)}'),
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
