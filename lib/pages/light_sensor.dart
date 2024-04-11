import 'package:flutter/material.dart';

class LightSensor extends StatefulWidget {
  const LightSensor({super.key});

  @override
  State<LightSensor> createState() => _LightSensorState();
}

class _LightSensorState extends State<LightSensor> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Light Sensor Page",
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
