// home page
import 'dart:async';

import 'package:flutter/material.dart';

class Task7 extends StatefulWidget {
  const Task7({super.key});

  @override
  State<Task7> createState() => _Task7State();
}

class _Task7State extends State<Task7> {
  Widget _child = CircularProgressIndicator();
  Widget _child2 = Icon(Icons.home);
  var listOfProducts = [];

  void callOpenAiApi() async {
    // await response from the API
    //var response = await https request (uri)
    // when response ready call setState (repaint the widget or screen with the response)
    await Future.delayed(
        const Duration(seconds: 3)); // Correct usage of Future.delayed
    if (mounted) {
      // Important: Check if the widget is still mounted
      setState(() {
        // _child = const Text(
        //     "Home Page"); // Make "Home Page" const for better performance
        _child = _child2;
      });
    }
  }

  // void sendSms(String message) async {
  //var studentsNumbers = [07854545454, 079953535353];
  // await http request to URI (SMS SERVER) {SMSMESAGE + LIST OF RECIVERS}
  // }
  /**
   * void fetchProducts() async {
   * var response = await https(uri)
   * update data (listOfProducts) or Widgets 
   * }
   */
  @override
  void initState() {
    super.initState();
    callOpenAiApi(); // Call startTimer when the widget initializes
    // send sms to students group
    // sendSms("Hello from task 7");
    // fetchProduct();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('async function simulation'),
      ),
      body: Container(
        child: Center(
          //child: Text('Home Page'),
          child: _child,
        ),
      ),
    );
  }
}
