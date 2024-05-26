import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MotionDetectionChart extends StatefulWidget {
  final List<int> motionCounts;

  const MotionDetectionChart({super.key, required this.motionCounts});

  @override
  State<MotionDetectionChart> createState() => _MotionDetectionChartState();
}

class _MotionDetectionChartState extends State<MotionDetectionChart> {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: _getBarGroups(),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: _getBottomTitles,
                    reservedSize: 28,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    int today = DateTime.now()
        .weekday; // This will give a number from 1 (Monday) to 7 (Sunday)
    int index = (value.toInt() + today - 1) %
        days.length; // Adjust the index based on the current day
    String text = days[index];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child:
          Text(text, style: const TextStyle(color: Colors.black, fontSize: 14)),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(widget.motionCounts.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: widget.motionCounts[index].toDouble(),
            color: Colors.blue,
            width: 15,
          ),
        ],
      );
    });
  }
}
