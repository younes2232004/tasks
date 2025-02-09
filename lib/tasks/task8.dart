// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
// import http
import 'package:http/http.dart' as http;

class Task8 extends StatefulWidget {
  const Task8({super.key});

  @override
  State<Task8> createState() => _Task8State();
}

class _Task8State extends State<Task8> {
  String sample = "";
  //**************************************** function name and returned data typ 1
  //void fetchAllProducts()async {}
  void fetchAllProducts() async {
    // ************************************** past code from postman (implementation)2
    var request =
        http.Request('GET', Uri.parse('https://fakestoreapi.com/products'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("========================== Retrived data");
      print(await response.stream.bytesToString());
    } else {
      print("Error");
      print(response.reasonPhrase);
    }
  }
  // void callOpenAiApi(data (video to data )) async {
  //   // ************************************** past code from postman (implementation)2
  //   var request =
  //       http.Request('POST', Uri.parse('https://fakestoreapi.com/products'));

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  // sample = await response.stream.bytesToString();
  //     print("========================== Retrived data");
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print("Error");
  //     print(response.reasonPhrase);
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // call async function **********************3
    fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Async real example using postman"),
        ),
        body: Container());
  }
}
