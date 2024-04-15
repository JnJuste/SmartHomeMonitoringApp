import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';

class LightSensorPage extends StatefulWidget {
  const LightSensorPage({super.key});

  @override
  State<LightSensorPage> createState() => _LightSensorPageState();
  
}

class _LightSensorPageState extends State<LightSensorPage> {
  late final StreamSubscription<int> _lightSensorSubscription;

  int _animationValue = 0;

  final Duration _animationDuration = const Duration(seconds: 3);

  final Color _baseColor = Color.fromARGB(255, 255, 255, 255);

  Color _backgroundColor = Colors.white;

  // Darkens the given color by a specified amount.
  Color _darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final double lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  @override
  void initState() {
    super.initState();

    LightSensor.hasSensor().then((hasSensor) {
      if (hasSensor) {
        _lightSensorSubscription = LightSensor.luxStream().listen((lux) {
          setState(() {
            _animationValue = lux;
            _backgroundColor = _darken(_baseColor, 0.5 - lux / 1000);
          });
        });
      } else {
        print('Device does not have a light sensor');
      }
    });
  }

  @override
  void dispose() {
    _lightSensorSubscription.cancel();
    super.dispose();
  }


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
      backgroundColor: _backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Light Level: $_animationValue lux',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _backgroundColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: _animationDuration,
              width: 20 + _animationValue * 0.5,
              height: 20 + _animationValue * 0.5,
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.lightbulb_outline,
                  size: 50 + _animationValue * 0.2,
                  color: _backgroundColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

