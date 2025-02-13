import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../models/product.dart';

class Details extends StatelessWidget {
  final Product product;
  const Details({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details View"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.deepOrange),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: PhotoView(
                  imageProvider: NetworkImage(
                      product.image ?? 'https://via.placeholder.com/150'),
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.white),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? 'No Title',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${product.price?.toStringAsFixed(2) ?? '0.00'}",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description ?? 'No description available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("Add to Cart",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
