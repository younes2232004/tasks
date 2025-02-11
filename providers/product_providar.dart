import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tasks/models/product.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  // 1. Variables
  final List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  // 2. Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 3. Fetch products from API
  Future<void> fetchAllProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        _products.clear(); // Clear list before updating to avoid duplicates
        _products.addAll(jsonData.map((product) => Product.fromJson(product)));
      } else {
        _errorMessage = "Failed to load data";
      }
    } catch (error) {
      _errorMessage = "Error: $error";
      debugPrint("Fetch error: $error"); // Improved debugging
    }

    _isLoading = false;
    notifyListeners();
  }
}
