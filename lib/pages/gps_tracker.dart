import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class GpsTracker extends StatefulWidget {
  const GpsTracker({super.key});

  @override
  _GpsTrackerState createState() => _GpsTrackerState();
}

class _GpsTrackerState extends State<GpsTracker> {
  String? _locationMessage;
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      _getLocation().then((value) {});
    } else if (status.isDenied) {
      _showLocationPermissionDialog(context);
    } else if (status.isPermanentlyDenied) {
      _showLocationPermissionDialog(context);
    }
  }

  Future<void> _showLocationPermissionDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
              'Location permission is required to fetch your location. Please enable it in app settings.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                // Open app settings
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _locationMessage = ' ${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      print('Error fetching location: $e');
      setState(() {
        _locationMessage = 'Could not fetch location';
      });
    }
  }

  Future<void> _openMaps() async {
    try {
      if (_locationMessage != null) {
        String url =
            'https://www.google.com/maps/search/?api=1&query=$_locationMessage';
        Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not launch $url';
        }
      } else {
        throw 'Location message is null';
      }
    } catch (e) {
      print('Error opening maps: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error opening maps. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'GPS Tracker',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.redAccent, Colors.yellowAccent],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              if (_locationMessage != null)
                Column(
                  children: [
                    const Text(
                      'Your Current Coordinates are:',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _locationMessage!,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _openMaps,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        primary: Colors.blue,
                      ),
                      child: const Text(
                        'Open in Maps',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
