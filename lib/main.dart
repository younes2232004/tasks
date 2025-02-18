import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/login_provider.dart';
import 'components/task16.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Task16(),
    );
  }
}

// providers/product_provider.dart

class ProductProvider with ChangeNotifier {
  List<String> _products = [];
  List<String> get products => _products;

  void addProduct(String product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(String product) {
    _products.remove(product);
    notifyListeners();
  }
}

// providers/login_provider.dart

class LoginProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

// components/task16.dart

class Task16 extends StatelessWidget {
  const Task16({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 16')),
      body: const Center(child: Text('This is Task 16 Screen')),
    );
  }
}
