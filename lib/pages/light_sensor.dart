import 'package:flutter/material.dart';
import 'dart:async';

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
      body: Center(
        child: FutureBuilder<bool>(
          future: hasSensor(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              final bool hasSensor = snapshot.data!;
              if (hasSensor) {
                return StreamBuilder<int>(
                  stream: luxStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error');
                    } else {
                      return Text('Running on: ${snapshot.data} LUX');
                    }
                  },
                );
              } else {
                return const Text("Your device doesn't have a light sensor");
              }
            }
          },
        ),
      ),
    );
  }
}

Future<bool> hasSensor() async {
  await Future.delayed(const Duration(seconds: 2)); // Simulating a delay
  return true; // For demonstration purposes, always return true
}

Stream<int> luxStream() {
  return Stream.periodic(
      Duration(seconds: 1),
      (count) =>
          count * 100); // For demonstration purposes, return a periodic stream
}
