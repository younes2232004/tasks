// task 16 reusable compo
import 'package:flutter/material.dart';

class Task16 extends StatelessWidget {
  const Task16({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reusable components"),
      ),
      body: Center(
        child: Column(
          children: [
            // 1
            Row(
              children: [
                CustomButton(
                  text: 'Button1',
                  onPressed: () {
                    print("Button1 Pressed");
                  },
                ),
                CustomButton(
                  text: 'Button2',
                  onPressed: () {
                    print("Button2 Pressed");
                  },
                ),
              ],
            ),
            // 2
            ElevatedButton(
              onPressed: () {
                print("Button2 Pressed");
              },
              child: Text("Button2"),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
