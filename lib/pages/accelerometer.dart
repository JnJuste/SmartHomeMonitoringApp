import 'package:flutter/material.dart';

class Accelerometer extends StatefulWidget {
  const Accelerometer({super.key});

  @override
  State<Accelerometer> createState() => _AccelerometerState();
}

class _AccelerometerState extends State<Accelerometer> {
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
