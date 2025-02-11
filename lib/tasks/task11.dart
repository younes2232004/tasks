import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/product.dart';
// ********************************************************************************** 1 (import http)
import 'package:http/http.dart' as http;

// Product List Screen
class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // ******************************************************************************* 2 (list of (x) )
  late Future<List<Product>> futureProducts;

  // ******************************************************************************* 4 Function to Fetch Products
  Future<List<Product>> fetchAllProducts() async {
    // 1
    final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products')); // hold response value
    // 2
    if (response.statusCode == 200) {
      // 3
      List<dynamic> jsonData =
          json.decode(response.body); // (temp box decode response)
      //4 finaly
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  @override
  void initState() {
    super.initState();
    // ***************************************************************************** 3 (initialize late future value)
    futureProducts = fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      //1
      body: FutureBuilder<List<Product>>(
        //2
        future: futureProducts,
        //3
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products available"));
          }
          // 4 data to be used in list view
          List<Product> products = snapshot.data!;
          //5
          return ListView.builder(
            //6
            itemCount: products.length,
            //7
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(products[index].image ?? "",
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(products[index].title ?? "No Title"),
                  subtitle:
                      Text("\$${products[index].price?.toStringAsFixed(2)}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 20),
                      Text(products[index].rating?.rate?.toStringAsFixed(1) ??
                          "N/A"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
