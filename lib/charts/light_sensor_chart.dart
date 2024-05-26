import 'package:flutter/material.dart';

class LightChart extends StatefulWidget {
  const LightChart({super.key});

  @override
  State<LightChart> createState() => _LightChartState();
}

class _LightChartState extends State<LightChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Light Sensor Chart",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
    );
  }
}
