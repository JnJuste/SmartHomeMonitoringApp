import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MotionDetectorPage extends StatefulWidget {
  const MotionDetectorPage({super.key});

  @override
  State<MotionDetectorPage> createState() => _MotionDetectorPageState();
}

class _MotionDetectorPageState extends State<MotionDetectorPage> {
  bool _isMotionOrVibrationDetected = false;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  double motionThreshold = 25.0;
  double vibrationThreshold = 15.0;
  String _lastDetectionTimestamp = '';

  @override
  void initState() {
    super.initState();
    _initializeSensors();
    _initializeNotifications();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    // Check if the necessary permissions are granted
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      // Request permissions if they're not granted
      Map<Permission, PermissionStatus> statuses = await [
        Permission.notification,
      ].request();
      print(statuses[Permission.notification]);
    }
  }

  void _initializeSensors() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      _handleMotionAndVibration(event);
    });

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _handleMotionAndVibration(event);
    });
  }

  void _handleMotionAndVibration(dynamic event) {
    double totalAcceleration = event.x.abs() + event.y.abs() + event.z.abs();
    if (totalAcceleration > motionThreshold ||
        totalAcceleration > vibrationThreshold) {
      final DateTime now = DateTime.now();
      final formattedTimestamp =
          '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
      setState(() {
        _isMotionOrVibrationDetected = true;
        _lastDetectionTimestamp = formattedTimestamp;
      });

      // Trigger push notification
      _showNotification(
        'SECURITY ALERT!',
        'Motion or Vibration Detected at $_lastDetectionTimestamp.',
      );
    } else {
      setState(() {
        _isMotionOrVibrationDetected = false;
      });
    }
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  Future<void> _initializeNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'motion_detection_channel',
      'Motion Detection',
      channelDescription:
          'Notification Channel for Motion and Vibration Detection',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/app_icon',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Motion Detector/Accelerometer',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              _isMotionOrVibrationDetected
                  ? Icons.security
                  : Icons.accessibility,
              size: 100,
              color: _isMotionOrVibrationDetected ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              _isMotionOrVibrationDetected
                  ? 'Motion/Vibration Detected'
                  : 'No Motion or Vibration Detected',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isMotionOrVibrationDetected ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Last Detection: $_lastDetectionTimestamp',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
