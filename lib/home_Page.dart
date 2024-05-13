import 'package:assignment_sensor/pages/accelerometer.dart';
import 'package:assignment_sensor/pages/gps_tracker.dart';
import 'package:assignment_sensor/pages/location_fencing.dart';
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
    const LightSensorPage(),
    const LocationFencingPage(),
    const MagnetometerPage(),
    const MotionDetectorPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey,
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
              icon: Icon(Icons.fence_sharp),
              label: "Location Fence",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.compass_calibration),
              label: "Magnetometer",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.motion_photos_auto),
              label: "Accelerometer",
            ),
          ],
        ),
      ),
    );
  }
}
