import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Screens
import 'login_page.dart' as login;
import 'home_page.dart' as home;
import 'category_page.dart';
import 'electronics.dart';
import 'fashion.dart';
import 'kitchen.dart';
import 'books.dart';
import 'sports.dart';

// Your cart service import
import 'cart_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAMhRsoYvnFKNrtv5zczXxT5ZClEFG_uic',
        appId: '1:122195968692:web:REPLACE_WITH_WEB_APP_ID',
        messagingSenderId: '122195968692',
        projectId: 'crud-ea04d',
        storageBucket: 'crud-ea04d.appspot.com',
        authDomain: 'crud-ea04d.firebaseapp.com',
        measurementId: 'G-XXXXXXXXXX',
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAMhRsoYvnFKNrtv5zczXxT5ZClEFG_uic',
        appId: '1:122195968692:android:6335b9a0d35b6946aa8de1',
        messagingSenderId: '122195968692',
        projectId: 'crud-ea04d',
        storageBucket: 'crud-ea04d.appspot.com',
      ),
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color ben10Green = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAK Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: ben10Green,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: ben10Green),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ben10Green),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ben10Green, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: ben10Green),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ben10Green,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      routes: {
        '/category': (context) => const CategoryPage(),
        '/electronics': (context) => const ElectronicsProductsPage(),
        '/fashion': (context) => const FashionProductsPage(),
        '/kitchen': (context) => const KitchenProductsPage(),
        '/books': (context) => const BooksProductsPage(),
        '/sports': (context) => const SportsProductsPage(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            final user = snapshot.data!;
            final cartService = CartService(user.uid);
            return home.HomePage(cartService: cartService);
          } else {
            return const login.LoginPage();
          }
        },
      ),
    );
  }
}
