import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class PedometerPage extends StatefulWidget {
  const PedometerPage({super.key});

  @override
  State<PedometerPage> createState() => _PedometerPage();
}

class _PedometerPage extends State<PedometerPage> {
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';

  @override
  void initState() {
    super.initState();
    startListening();
  }

  void startListening() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onData).onError(onError);
  }

  void onData(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onError(error) {
    print('Flutter Pedometer Error: $error');
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
            const Icon(
              Icons.directions_walk,
              size: 50,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              'Steps taken: $_steps',
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
