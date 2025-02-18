import 'package:flutter/material.dart';
import 'package:tasks/models/product.dart';

class DetailsRaghad extends StatelessWidget {
  final Product product;
  const DetailsRaghad({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? 'No Title'),
      ), // 1 title text

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Image of the product
              Center(
                child: Image.network(
                  product.image ?? 'https://via.placeholder.com/200',
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Product title
              Text(
                product.title ?? 'No Title',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // 3. Product price
              Text(
                "Price: \$${product.price?.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),

              // 4. Product description
              Text(
                product.description ?? 'No Description',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              // 5. Rating (stars)
              Row(
                children: [
                  for (int i = 1; i <= 5; i++)
                    Icon(
                      Icons.star,
                      color: (product.rating?.rate ?? 0) >= i
                          ? Colors.orange
                          : Colors.grey,
                      size: 20,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    "${product.rating?.rate?.toStringAsFixed(1) ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16, color: Colors.orange),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 6. Add to Cart button
              ElevatedButton.icon(
                onPressed: () {
                  // Add to cart functionality goes here
                },
                icon: Icon(Icons.shopping_cart),
                label: Text("Add to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button color
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
