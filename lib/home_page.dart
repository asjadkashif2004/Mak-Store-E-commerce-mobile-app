import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'category_page.dart';
import 'cart_page.dart';
import 'cart_service.dart';

import 'electronics.dart';
import 'fashion.dart';
import 'kitchen.dart';
import 'books.dart';
import 'sports.dart';

class HomePage extends StatefulWidget {
  final CartService cartService;

  const HomePage({super.key, required this.cartService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final Map<String, Widget> categoryMap = {
    'electronics': const ElectronicsProductsPage(),
    'fashion': const FashionProductsPage(),
    'kitchen': const KitchenProductsPage(),
    'books': const BooksProductsPage(),
    'sports': const SportsProductsPage(),
  };

  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/');
  }

  void navigateToCategory() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CategoryPage()));
  }

  void _handleSearch() {
    final query = _searchController.text.toLowerCase().trim();
    final matchedPage = categoryMap.entries.firstWhere(
      (entry) => query.contains(entry.key),
      orElse: () => const MapEntry('', SizedBox()),
    );

    if (matchedPage.key.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => matchedPage.value),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Category not found')));
    }
  }

  final List<String> menuItems = [
    'Home',
    'Category',
    'Cart',
    'Orders',
    'Profile',
    'Logout',
  ];

  // Map menu items to icons
  final Map<String, IconData> menuIcons = {
    'Home': Icons.home,
    'Category': Icons.category,
    'Cart': Icons.shopping_cart,
    'Orders': Icons.list_alt,
    'Profile': Icons.person,
    'Logout': Icons.logout,
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MAK Store',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            fontFamily: 'Georgia',
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Cart',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CartPage(cartService: widget.cartService),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ListTile(
                  leading: Icon(menuIcons[item], color: Colors.white),
                  title: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                  hoverColor: const Color.fromARGB(51, 76, 175, 80),
                  onTap: () {
                    Navigator.of(context).pop();
                    switch (item) {
                      case 'Logout':
                        logout();
                        break;
                      case 'Category':
                        navigateToCategory();
                        break;
                      case 'Cart':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CartPage(cartService: widget.cartService),
                          ),
                        );
                        break;
                      case 'Home':
                        // Maybe pop until home or do nothing since already home
                        break;
                      default:
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$item page coming soon...')),
                        );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Search Banner
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Categories (e.g. Electronics)',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onSubmitted: (_) => _handleSearch(),
              textInputAction: TextInputAction.search,
            ),

            const SizedBox(height: 20),

            // Responsive Banner Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/makstore.png',
                width: screenWidth * 0.95,
                height: (screenWidth * 0.95) * 0.5,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 30),

            // Welcome Text
            const Text(
              'Welcome to MAK Store!',
              style: TextStyle(
                fontFamily: 'Lobster',
                fontSize: 28,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Stylish description paragraph about the app
            const Text(
              'Discover a wide range of products from electronics, fashion, kitchen essentials, books, and sports gear — all at your fingertips. Enjoy a smooth shopping experience with our user-friendly interface and secure checkout.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 60),

            // Footer text aligned to bottom right
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '© Muhammad Asjad Kashif All rights reserved',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
