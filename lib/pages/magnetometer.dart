import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MagnetometerPage extends StatefulWidget {
  const MagnetometerPage({super.key});

  @override
  State<MagnetometerPage> createState() => _MagnetometerPageState();
}

class _MagnetometerPageState extends State<MagnetometerPage> {
  MagnetometerEvent _magneticEvent = MagnetometerEvent(0, 0, 0);
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = magnetometerEvents.listen((event) {
      setState(() {
        _magneticEvent = event;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  double calculatorDegrees(double x, double y) {
    double heading = atan2(x, y);
    //Convert from radians to degrees
    heading = heading * 180 / pi;

    //Ensure that the heading is between 0 and 360 degrees
    if (heading > 0) {
      heading -= 360;
    }
    return heading * -1;
  }

  @override
  Widget build(BuildContext context) {
    final degrees = calculatorDegrees(_magneticEvent.x, _magneticEvent.y);
    final angle = 1 * pi / 180 * degrees;

    String direction = 'N';
    if (degrees >= -22.5 && degrees < 22.5) {
      direction = 'N';
    } else if (degrees >= 22.5 && degrees < 67.5) {
      direction = 'NE';
    } else if (degrees >= 67.5 && degrees < 112.5) {
      direction = 'E';
    } else if (degrees >= 112.5 && degrees < 157.5) {
      direction = 'SE';
    } else if (degrees >= 157.5 || degrees < -157.5) {
      direction = 'S';
    } else if (degrees >= -157.5 && degrees < -112.5) {
      direction = 'SW';
    } else if (degrees >= -112.5 && degrees < -67.5) {
      direction = 'W';
    } else if (degrees >= -67.5 && degrees < -22.5) {
      direction = 'NW';
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        centerTitle: true,
        title: const Text(
          "Compass/Magnetometer",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Degree: ${degrees.toStringAsFixed(0)} °",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Direction: $direction",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 30.0),
            // Let's show the compass
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("assets/cadrant.png"),
                  Transform.rotate(
                    angle: angle,
                    child: Image.asset(
                      "assets/compass.png",
                      scale: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
