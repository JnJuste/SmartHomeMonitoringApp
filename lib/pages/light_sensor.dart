import 'package:flutter/material.dart';

class LightSensor extends StatefulWidget {
  const LightSensor({super.key});

  @override
  State<LightSensor> createState() => _LightSensorState();
}

class _LightSensorState extends State<LightSensor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        centerTitle: true,
        title: const Text(
          "Light Sensor",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
