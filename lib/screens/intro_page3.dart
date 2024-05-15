import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3>
    with SingleTickerProviderStateMixin {
  // Controller
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller here
    super.dispose();
  }

  bool smartHome = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set container to full screen size
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  smartHome = !smartHome;
                  if (smartHome) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                });
              },
              child: Lottie.asset(
                "assets/smartHome3.json",
                controller: _controller,
                width: 410,
                height: 410,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 10),
            // Remove the Expanded widget
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Stay Connected, Anytime, Anywhere',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Whether you’re at home, at work, or on vacation, our Smart Home Monitoring System keeps you connected to your home, giving you peace of mind.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
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
