import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'category_page.dart';

import 'cart_page.dart';

import 'cart_service.dart'; // Import from lib directly

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final CartService cartService;

  @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Handle not logged in user appropriately, e.g. redirect to login page

      throw Exception('User not logged in');
    }

    cartService = CartService(userId);
  }

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

  final List<String> menuItems = [
    'Home',

    'Category',

    'Cart',

    'Orders',

    'Profile',

    'Logout',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAK Store'),

        backgroundColor: Colors.green,
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
                  title: Text(
                    item,

                    style: const TextStyle(color: Colors.white),
                  ),

                  hoverColor: const Color.fromARGB(51, 76, 175, 80),

                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer first

                    if (item == 'Logout') {
                      logout();
                    } else if (item == 'Category') {
                      navigateToCategory();
                    } else if (item == 'Cart') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => CartPage(cartService: cartService),
                        ),
                      );
                    } else {
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

      body: const Center(
        child: Text(
          'Welcome to MAK Store!',

          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
