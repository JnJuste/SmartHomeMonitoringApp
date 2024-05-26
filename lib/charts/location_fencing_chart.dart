import 'package:flutter/material.dart';

class LocationFencingChart extends StatefulWidget {
  const LocationFencingChart({super.key});

  @override
  State<LocationFencingChart> createState() => _LocationFencingChartState();
}

class _LocationFencingChartState extends State<LocationFencingChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Location Fencing Chart",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
    );
  }
}
