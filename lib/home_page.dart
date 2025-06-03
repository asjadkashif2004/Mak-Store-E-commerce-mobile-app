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

  final Map<String, IconData> menuIcons = {
    'Home': Icons.home,
    'Category': Icons.category,
    'Cart': Icons.shopping_cart,
    'Orders': Icons.list_alt,
    'Profile': Icons.person,
    'Logout': Icons.logout,
  };

  // Animated welcome message (fade-in)
  Widget _animatedWelcomeMessage() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: const Text(
        'Welcome to MAK Store!',
        style: TextStyle(
          fontFamily: 'Lobster',
          fontSize: 28,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Category icon button widget
  Widget _categoryIconButton(String label, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.green.shade700),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

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
                        // Already home
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
              style: const TextStyle(
                color: Colors.black,
              ), // Black input text color
              decoration: InputDecoration(
                hintText: 'Search Categories (e.g. Electronics)',
                hintStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
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

            // Category Icons Row - Centered
            Center(
              child: SizedBox(
                height: 110,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _categoryIconButton(
                      'Electronics',
                      Icons.devices,
                      const ElectronicsProductsPage(),
                    ),
                    _categoryIconButton(
                      'Sports',
                      Icons.sports_soccer,
                      const SportsProductsPage(),
                    ),
                    _categoryIconButton(
                      'Kitchen',
                      Icons.kitchen,
                      const KitchenProductsPage(),
                    ),
                    _categoryIconButton(
                      'Books',
                      Icons.book,
                      const BooksProductsPage(),
                    ),
                    _categoryIconButton(
                      'Fashion',
                      Icons.shopping_bag,
                      const FashionProductsPage(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Banner Image
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

            // Animated Welcome Message
            _animatedWelcomeMessage(),

            const SizedBox(height: 16),

            // Description paragraph
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

            // Footer Text
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
