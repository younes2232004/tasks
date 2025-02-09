// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
\ class Task10 extends StatefulWidget {
  const Task10({super.key});

  @override
  State<Task10> createState() => _Task10State();
}

class _Task10State extends State<Task10> {
  String sample = "Loading...";

  void fetchAllProducts() async {
    var request = http.Request('GET', Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      setState(() {
        sample = responseBody;
      });
    } else {
      setState(() {
        sample = "Error: ${response.reasonPhrase}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Async API Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(sample),
        ),
      ),
    );
  }
}
