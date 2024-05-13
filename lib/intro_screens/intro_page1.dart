import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1>
    with SingleTickerProviderStateMixin {
  //Controller
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
          mainAxisAlignment: MainAxisAlignment.center, // Add this line
          children: [
            GestureDetector(
              onTap: () {
                if (smartHome == false) {
                  smartHome = true;
                  _controller.forward();
                } else {
                  smartHome = false;
                  _controller.reverse();
                }
              },
              child: Lottie.asset(
                "assets/smartHome.json",
                controller: _controller,
                width: 410, // Reduce the width
                height: 410, // Reduce the height
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 10), // Add this line
            // Remove the Expanded widget
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Smart Home Monitoring System',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Experience the comfort of automation with our Smart Home Monitoring System.',
                    style: TextStyle(
                      fontSize: 18,
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
