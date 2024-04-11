import 'package:flutter/material.dart';

class GpsTracker extends StatefulWidget {
  const GpsTracker({super.key});

  @override
  State<GpsTracker> createState() => _GpsTrackerState();
}

class _GpsTrackerState extends State<GpsTracker> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "GPS Tracker Page",
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
