import 'dart:developer';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:assignment_sensor/pages/accelerometer.dart';
import 'package:assignment_sensor/pages/gps_tracker.dart';
import 'package:assignment_sensor/pages/magnetometer.dart';
import 'package:assignment_sensor/pages/light_sensor.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///Controller to Handle Page View qnd initial Page
  final _pageController = PageController(initialPage: 0);

  ///Controller to handle bottom nav bar and also handles intial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Widget list
  final List<Widget> bottomBarPages = [
    const LightSensorPage(),
    const MagnetometerPage(),
    const MotionDetectorPage(),
    const GpsTracker(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Smart Home Monitoring System")),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: const Color(0xFF424242),
              showLabel: false,
              notchColor: const Color(0xFF424242),

              /// Restart app if youchange removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: const [
                /// Light Sensor
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.light,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.light,
                    color: Colors.grey,
                  ),
                  itemLabel: 'Light Sensor',
                ),

                /// Magnetometer
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.compass_calibration,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.compass_calibration,
                    color: Colors.grey,
                  ),
                  itemLabel: 'Magnetometer',
                ),

                /// Accelerometer
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.motion_photos_auto,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.motion_photos_auto,
                    color: Colors.grey,
                  ),
                  itemLabel: 'Accelerometer',
                ),

                /// GPS Tracker
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.gps_fixed,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.gps_fixed,
                    color: Colors.grey,
                  ),
                  itemLabel: 'GPS Tracker',
                ),
              ],
              onTap: (index) {
                /// Perform Action
                log('Current selected index $index');
                _pageController.jumpToPage(index);
              },
              kBottomRadius: 25, // Example radius value
              kIconSize: 25,
            )
          : null,
    );
  }
}

// api_keys.dart
// ignore: constant_identifier_names
const String GOOGLE_MAPS_API_KEY = 'AIzaSyCOJZKI-qRe5R4NCXpIVzVb5i8NSAvMs0Y';
