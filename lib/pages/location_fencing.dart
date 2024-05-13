import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geofence_flutter/geofence_flutter.dart';

class LocationFencingPage extends StatefulWidget {
  const LocationFencingPage({super.key});

  @override
  State<LocationFencingPage> createState() => _LocationFencingPageState();
}

class _LocationFencingPageState extends State<LocationFencingPage> {
  late StreamSubscription<GeofenceEvent> _geofenceEventSubscription;
  late Position _currentPosition;
  bool _isInsideHome = false;
  bool _isInsideWork = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _setupGeofencing();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _setupGeofencing() {
    _geofenceEventSubscription =
        Geofence.getGeofenceStream()!.listen((GeofenceEvent event) {
      if (event.name == 'Home') {
        setState(() {
          _isInsideHome = event.runtimeType == GeofenceEvent.enter;
        });
      } else if (event.name == 'Work') {
        setState(() {
          _isInsideWork = event.runtimeType == GeofenceEvent.enter;
        });
      }
    });
  }

  @override
  void dispose() {
    _geofenceEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        centerTitle: true,
        title: const Text(
          "Location Fencing",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'Current Location: ${_currentPosition != null ? _currentPosition.latitude.toString() + ', ' + _currentPosition.longitude.toString() : 'Unknown'}'),
            const SizedBox(height: 20),
            Text('Home: ${_isInsideHome ? 'Inside' : 'Outside'}'),
            const SizedBox(height: 20),
            Text('Work: ${_isInsideWork ? 'Inside' : 'Outside'}'),
          ],
        ),
      ),
    );
  }
}
