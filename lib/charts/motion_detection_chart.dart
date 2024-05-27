import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MotionDetectionChart extends StatefulWidget {
  final List<Map<DateTime, double>> motionDetectionData;

  const MotionDetectionChart({super.key, required this.motionDetectionData});

  @override
  State<MotionDetectionChart> createState() => _MotionDetectionChartState();
}

class _MotionDetectionChartState extends State<MotionDetectionChart> {
  List<FlSpot> _generateSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < widget.motionDetectionData.length; i++) {
      double motionValue = widget.motionDetectionData[i].values.first;
      spots.add(FlSpot(i.toDouble(), motionValue));
    }
    return spots;
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${_twoDigits(timestamp.hour)}:${_twoDigits(timestamp.minute)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Motion Detection Chart",
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
                  'Detection Number',
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
                    if (index < widget.motionDetectionData.length) {
                      DateTime timestamp =
                          widget.motionDetectionData[index].keys.first;
                      String time = _formatTimestamp(timestamp);
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
                color: Colors.pinkAccent,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.pinkAccent.withOpacity(0.3),
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
