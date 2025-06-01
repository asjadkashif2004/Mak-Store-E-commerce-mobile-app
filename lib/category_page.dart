import 'package:flutter/material.dart';

// Import all product pages
import 'electronics.dart';
import 'fashion.dart';
import 'kitchen.dart';
import 'books.dart';
import 'sports.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'title': 'Electronics and Tech',
      'image': 'assets/images/electronics.png',
      'page': ElectronicsProductsPage(),
    },
    {
      'title': 'Fashion',
      'image': 'assets/images/fashion.png',
      'page': FashionProductsPage(),
    },
    {
      'title': 'Home & Kitchen',
      'image': 'assets/images/kitchen.png',
      'page': KitchenProductsPage(),
    },
    {
      'title': 'Books',
      'image': 'assets/images/books.png',
      'page': BooksProductsPage(),
    },
    {
      'title': 'Sports & Outdoors',
      'image': 'assets/images/sports.png',
      'page': SportsProductsPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 3 / 3.5,
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withAlpha((0.2 * 255).toInt()),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          category['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      category['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
