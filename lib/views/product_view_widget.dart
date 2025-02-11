// task 13 UI

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providar/product_provider.dart';

class ProductViewWidget extends StatelessWidget {
  const ProductViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product View Widget"),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          // fixed
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (productProvider.errorMessage != null) {
            return Center(child: Text(productProvider.errorMessage!));
          } else if (productProvider.products.isEmpty) {
            return const Center(child: Text("No products available"));
          }

          return ListView.builder(
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              Product product = productProvider.products[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(
                    product.image ?? "",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.title ?? "No Title"),
                  subtitle: Text("\$${product.price?.toStringAsFixed(2)}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      Text(product.rating?.rate?.toStringAsFixed(1) ?? "N/A"),
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
