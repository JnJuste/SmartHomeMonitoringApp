import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class PedometerPage extends StatefulWidget {
  const PedometerPage({super.key});

  @override
  State<PedometerPage> createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage>
    with SingleTickerProviderStateMixin {
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';
  late AnimationController _controller;
  bool _isWalking = false;

  @override
  void initState() {
    super.initState();
    startListening();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
  }

  void startListening() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onData).onError(onError);
  }

  void onData(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
    if (!_controller.isAnimating) {
      _isWalking = true;
      _controller.repeat(reverse: true);
    }
  }

  void onError(error) {
    print('Flutter Pedometer Error: $error');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        centerTitle: true,
        title: const Text(
          "Pedometer",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0.0, _isWalking ? _controller.value * 5 : 0.0),
                  child: const Icon(
                    Icons.directions_walk,
                    size: 50,
                    color: Colors.blue,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Steps taken: $_steps',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10),
            Text(
              _isWalking ? 'Walking' : 'Stopped',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
