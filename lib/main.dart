import 'package:flutter/material.dart';

// import 'tasks/task1.dart';
// import 'tasks/task2.dart';
import 'package:provider/provider.dart';
import 'providar/login_provider.dart';
import 'providar/product_provider.dart';
import 'providers/login_provider.dart';
import 'providers/product_provider.dart';
import 'tasks/task17.dart';
import 'views/product_view_widget.dart';


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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // this is task selector
      //home: const Task1(),
      //home: const Task2(),

      home: AuthScreen(),
    );
  }
}

AuthScreen() {
}