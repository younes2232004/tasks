// task 13 BL
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  // 1 vars
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  // 2 getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 3 async function fetch products from api
  Future<void> fetchAllProducts() async {
    // 3.1
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // 3.2
    try {
      // 3.2.1
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      // 3.2.2
      if (response.statusCode == 200) {
        // 3.2.2.2.1
        List<dynamic> jsonData = json.decode(response.body);
        _products =
            jsonData.map((product) => Product.fromJson(product)).toList();
      } else {
        // 3.2.2.2.2
        _errorMessage = "Failed to load data";
      }
    } catch (error) {
      _errorMessage = "Error: $error";
    }
    // 3.3
    _isLoading = false;
    notifyListeners();
  }
}
