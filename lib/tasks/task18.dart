import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_core/firebase_core.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? userId;

  Future<void> signUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() => userId = userCredential.user?.uid);
      await FirebaseFirestore.instance.collection("users ").doc(userId).set({
        "email ": emailController.text,
        "createdAt ": DateTime.now(),
      });
    } catch (e) {
      print(" Signup Error : $e");
    }
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() => userId = userCredential.user?.uid);
    } catch (e) {
      print(" Login Error : $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    setState(() => userId = null);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
