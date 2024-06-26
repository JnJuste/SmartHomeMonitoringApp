import 'dart:async';
import 'package:assignment_sensor/charts/location_fencing_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// Initialize local notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocationFencePage extends StatefulWidget {
  const LocationFencePage({super.key});

  @override
  State<LocationFencePage> createState() => _LocationFencePageState();
}

class _LocationFencePageState extends State<LocationFencePage> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final LatLng _kigaliCenter =
      const LatLng(-1.9441, 30.0619); // Coordinates for Kigali center
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? _currentP;
  Map<PolylineId, Polyline> polylines = {};
  final Map<PolygonId, Polygon> _polygons = {};
  StreamSubscription<LocationData>? _locationSubscription;
  bool _notificationSentOutSide = false;
  bool _notificationSentInSide = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) => {
              generatePolyLineFromPoints(coordinates),
            }),
      },
    );
    _createGeofence();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel(); // Cancel location updates subscription
    super.dispose();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Location Fencing",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LocationFencingChart()),
              );
            },
            child: const Text(
              "Chart",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const Icon(Icons.arrow_forward, color: Colors.black),
        ],
      ),
      body: _currentP == null
          ? const Center(
              child: Text(
                "Wait, Google Map is loading...",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: _kigaliCenter,
                zoom: 13,
              ),
              polygons: Set<Polygon>.of(_polygons.values),
              markers: {
                Marker(
                  markerId: const MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentP!,
                ),
                const Marker(
                    markerId: MarkerId("_sourceLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pGooglePlex),
                const Marker(
                    markerId: MarkerId("_destionationLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pApplePark)
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  void _triggerInSideNotification() async {
    if (!_notificationSentInSide) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'Map_channel', // Change this to match your channel ID
        'Map Notifications', // Replace with your own channel name
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'LOCATION GEOFENCING!',
        'You are inside of the geographical boundaries of Kigalis',
        platformChannelSpecifics,
      );
      print('Inside geofence notification sent');
      _notificationSentInSide = true;
      _notificationSentOutSide = false;
    }
  }

  void _triggerOutSideNotification() async {
    if (!_notificationSentOutSide) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'Map_channel', // Change this to match your channel ID
        'Map Notifications', // Replace with your own channel name
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'LOCATION GEOFENCING!',
        'You are outside of the geographical boundaries of Kigali',
        platformChannelSpecifics,
      );
      print('Outside geofence notification sent');
      _notificationSentOutSide = true;
      _notificationSentInSide = false;
    }
  }

  void _createGeofence() {
    // Define the boundaries for the larger geofence around Kigali
    List<LatLng> kigaliBoundaries = [
      const LatLng(-1.9740, 30.0274), // Northwest corner
      const LatLng(-1.9740, 30.1300), // Northeast corner
      const LatLng(-1.8980, 30.1300), // Southeast corner
      const LatLng(-1.8980, 30.0274), // Southwest corner
    ];

    // Create a polygon to represent the geofence boundaries
    PolygonId polygonId = const PolygonId('kigali');
    Polygon polygon = Polygon(
      polygonId: polygonId,
      points: kigaliBoundaries,
      strokeWidth: 2,
      strokeColor: Colors.blue,
      fillColor: Colors.blue.withOpacity(0.3),
    );

    // Add the polygon to the map
    setState(() {
      _polygons[polygonId] = polygon;
    });

    // Start location updates subscription to monitor device's location
    _startLocationUpdates();
  }

  void _startLocationUpdates() async {
    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      // Check if the device's location is inside or outside the geofence
      bool insideGeofence = _isLocationInsideGeofence(
          currentLocation.latitude!, currentLocation.longitude!);

      if (insideGeofence && !_notificationSentInSide) {
        _triggerInSideNotification();
        _notificationSentInSide = true;
        _notificationSentOutSide = false;
      } else if (!insideGeofence && !_notificationSentOutSide) {
        _triggerOutSideNotification();
        _notificationSentOutSide = true;
        _notificationSentInSide = false;
      }
    });
  }

  bool _isLocationInsideGeofence(double latitude, double longitude) {
    // Check if the provided location is inside the geofence boundaries
    bool isInside = false;
    List<LatLng> kigaliBoundaries = [
      const LatLng(-1.9740, 30.0274),
      const LatLng(-1.9740, 30.1300),
      const LatLng(-1.8980, 30.1300),
      const LatLng(-1.8980, 30.0274),
    ];

    // Algorithm to determine if a point is inside a polygon
    int i, j = kigaliBoundaries.length - 1;
    for (i = 0; i < kigaliBoundaries.length; i++) {
      if ((kigaliBoundaries[i].latitude < latitude &&
                  kigaliBoundaries[j].latitude >= latitude ||
              kigaliBoundaries[j].latitude < latitude &&
                  kigaliBoundaries[i].latitude >= latitude) &&
          (kigaliBoundaries[i].longitude <= longitude ||
              kigaliBoundaries[j].longitude <= longitude)) {
        if (kigaliBoundaries[i].longitude +
                (latitude - kigaliBoundaries[i].latitude) /
                    (kigaliBoundaries[j].latitude -
                        kigaliBoundaries[i].latitude) *
                    (kigaliBoundaries[j].longitude -
                        kigaliBoundaries[i].longitude) <
            longitude) {
          isInside = !isInside;
        }
      }
      j = i;
    }
    return isInside;
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        LatLng newLocation =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);

        // Update the marker to the new location
        updateMarkerAndCircle(newLocation);

        // Optionally, keep track of the path by adding to your polyline
        addLocationToPolyline(newLocation);

        _cameraToPosition(newLocation);
      }
    });
  }

  void updateMarkerAndCircle(LatLng newLocation) {
    setState(() {
      _currentP = newLocation;
      // Update your marker or create a new one if needed
    });
  }

  void addLocationToPolyline(LatLng newLocation) {
    setState(() {
      // Check if polyline exists, if not create one
      if (polylines.containsKey(const PolylineId("path"))) {
        final polyline = polylines[const PolylineId("path")]!;
        final updatedPoints = List<LatLng>.from(polyline.points)
          ..add(newLocation);
        polylines[const PolylineId("path")] =
            polyline.copyWith(pointsParam: updatedPoints);
      } else {
        // Create new polyline if it doesn't exist
        polylines[const PolylineId("path")] = Polyline(
          polylineId: const PolylineId("path"),
          color: Colors.blue,
          points: [newLocation],
          width: 5,
        );
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDMZQjVDaIRAl8Ov_IRmAwcq5W-4tMFMlc',
      PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
