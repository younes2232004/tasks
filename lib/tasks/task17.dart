import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Task17 extends StatefulWidget {
  const Task17({super.key});

  @override
  State<Task17> createState() => _LoginState();
}

class _LoginState extends State< Task17> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _task17() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print(" Logged ␣in␣as:␣${userCredential.user?.email}");
    } on FirebaseAuthException catch (e) {
      print(" Login ␣ error :␣${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
}
}
