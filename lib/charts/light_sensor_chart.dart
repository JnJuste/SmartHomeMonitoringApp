import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LightChart extends StatefulWidget {
  const LightChart({super.key});

  @override
  State<LightChart> createState() => _LightChartState();
}

class _LightChartState extends State<LightChart> {
  List<FlSpot> _generateSpots() {
    List sensorData = LightSensorData._instance.readings
        .map((reading) => reading['lux'])
        .toList();

    List<FlSpot> spots = [];
    for (int i = 0; i < sensorData.length; i++) {
      spots.add(FlSpot(i.toDouble(), sensorData[i].toDouble()));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Light Sensor Chart",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.3),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return const FlLine(
                  color: Colors.transparent,
                  strokeWidth: 0,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                axisNameWidget: const Text(
                  'Lux Level',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                axisNameSize: 30,
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
              bottomTitles: AxisTitles(
                axisNameWidget: const Text(
                  'Time',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                axisNameSize: 30,
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < LightSensorData._instance.readings.length) {
                      var reading = LightSensorData._instance.readings[index];
                      DateTime timestamp = reading['timestamp'];
                      String time =
                          "${timestamp.hour}h:${timestamp.minute.toString().padLeft(2, '0')}";
                      return Text(
                        time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border:
                  Border.all(color: Colors.black.withOpacity(0.1), width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: _generateSpots(),
                isCurved: true,
                barWidth: 5,
                color: Colors.teal,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.teal.withOpacity(0.3),
                ),
                dotData: const FlDotData(
                  show: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LightSensorData {
  static final LightSensorData _instance = LightSensorData._internal();
  factory LightSensorData() => _instance;
  LightSensorData._internal();

  final List<Map<String, dynamic>> _readings = [];
  List<Map<String, dynamic>> get readings => _readings;

  void addReading(int reading) {
    _readings.add({
      'lux': reading,
      'timestamp': DateTime.now(),
    });
    if (_readings.length > 100) {
      _readings.removeAt(0);
    }
  }
}
