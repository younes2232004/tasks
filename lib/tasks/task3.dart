import 'package:flutter/material.dart';

class Task3 extends StatelessWidget {
  Task3({super.key});
  final products = List.generate(100, (index) => 'Product $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task3'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => ListTile(
          tileColor: (index % 2 == 0) ? Colors.grey[200] : Colors.white,
          title: Text('Product $index'),
        ),
      ),
    );
  }
}
