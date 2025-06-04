import 'package:flutter/material.dart';

// Import all product pages
import 'electronics.dart';
import 'fashion.dart';
import 'kitchen.dart';
import 'books.dart';
import 'sports.dart';
import 'medicines.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'title': 'Electronics',
      'image': 'assets/images/electronics2.png',
      'page': ElectronicsProductsPage(),
    },
    {
      'title': 'Fashion',
      'image': 'assets/images/clothing3.png',
      'page': FashionProductsPage(),
    },
    {
      'title': 'Kitchen',
      'image': 'assets/images/kitchen.png',
      'page': KitchenProductsPage(),
    },
    {
      'title': 'Books',
      'image': 'assets/images/books1.png',
      'page': BooksProductsPage(),
    },
    {
      'title': 'Sports',
      'image': 'assets/images/sports1.png',
      'page': SportsProductsPage(),
    },

    {
      'title': 'Medicines',
      'image': 'assets/images/medicines.png',
      'page': MedicinesProductsPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop by Category'),
        backgroundColor: Colors.green[700],
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => category['page']),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          category['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
