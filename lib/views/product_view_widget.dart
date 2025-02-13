// task 13 UI

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks/providar/product_provider.dart';
import 'package:tasks/views/details.dart';

import '../models/product.dart';

class ProductViewWidget extends StatefulWidget {
  const ProductViewWidget({super.key});

  @override
  State<ProductViewWidget> createState() => _ProductViewWidgetState();
}

class _ProductViewWidgetState extends State<ProductViewWidget> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchAllProducts();
    });
  }

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
                  onTap: () {
                    print(" title : ${product.title} , passed to details page");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SecondScreen(product: product),
//               ),
//             );
//           },


// CODE WITH ERROR (fetchAllProducts not called)
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../models/product.dart';
// import '../providers/product_provider.dart';

// class ProductViewWidget extends StatelessWidget {
//   const ProductViewWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Product View Widget"),
//       ),
//       body: Consumer<ProductProvider>(
//         builder: (context, productProvider, child) {
//           // fixed
//           if (productProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (productProvider.errorMessage != null) {
//             return Center(child: Text(productProvider.errorMessage!));
//           } else if (productProvider.products.isEmpty) {
//             return const Center(child: Text("No products available"));
//           }

//           return ListView.builder(
//             itemCount: productProvider.products.length,
//             itemBuilder: (context, index) {
//               Product product = productProvider.products[index];
//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 child: ListTile(
//                   leading: Image.network(
//                     product.image ?? "",
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                   ),
//                   title: Text(product.title ?? "No Title"),
//                   subtitle: Text("\$${product.price?.toStringAsFixed(2)}"),
//                   trailing: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.star, color: Colors.orange, size: 20),
//                       Text(product.rating?.rate?.toStringAsFixed(1) ?? "N/A"),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// fast sol 
// SOL 1 CONVERT TO STFULL THEN 
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     Provider.of<ProductProvider>(context, listen: false).fetchAllProducts();
//   });
// }



// SOL 2 (Best)

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/product.dart';
// import '../providers/product_provider.dart';

// class ProductViewWidget extends StatelessWidget {
//   const ProductViewWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final productProvider = Provider.of<ProductProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Product View Widget")),
//       body: FutureBuilder(
//         future: productProvider.fetchAllProducts(), // Fetch products once
//         builder: (context, snapshot) {
//           final provider = Provider.of<ProductProvider>(context);

//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (provider.errorMessage != null) {
//             return Center(child: Text(provider.errorMessage!));
//           } else if (provider.products.isEmpty) {
//             return const Center(child: Text("No products available"));
//           }

//           return ListView.builder(
//             itemCount: provider.products.length,
//             itemBuilder: (context, index) {
//               Product product = provider.products[index];
//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 child: ListTile(
//                   leading: Image.network(
//                     product.image ?? "",
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                   ),
//                   title: Text(product.title ?? "No Title"),
//                   subtitle: Text("\$${product.price?.toStringAsFixed(2)}"),
//                   trailing: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.star, color: Colors.orange, size: 20),
//                       Text(product.rating?.rate?.toStringAsFixed(1) ?? "N/A"),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }