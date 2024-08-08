import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/habit.dart';

class ProgressChart extends StatelessWidget {
  final List<Habit> habits;
  const ProgressChart({required this.habits, super.key});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: const ChartTitle(text: 'Habit Progress'),
      legend: const Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<Habit, String>(
          dataSource: habits,
          xValueMapper: (Habit habit, _) => habit.title,
          yValueMapper: (Habit habit, _) => habit.completedDates.length,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}
