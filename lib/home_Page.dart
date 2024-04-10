import 'package:assignment_sensor/pages/gps_tracker.dart';
import 'package:assignment_sensor/pages/accelerometer.dart';
import 'package:assignment_sensor/pages/magnetometer.dart';
import 'package:assignment_sensor/pages/light_sensor.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const GpsTracker(),
    const LightSensor(),
    const Accelerometer(),
    const Magnetometer(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.gps_fixed),
            label: "GPS Tracker",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.light),
            label: "Light Sensor",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk_outlined),
            label: "Accelerometer",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration),
            label: "Magnetometer",
          ),
        ],
      ),
    );
  }
}
