import 'package:flutter/material.dart';

class Accelerometer extends StatelessWidget {
  const Accelerometer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Accelerometer Page",
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
