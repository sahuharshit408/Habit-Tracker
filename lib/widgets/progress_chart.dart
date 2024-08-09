import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/habit.dart';

class ProgressChart extends StatelessWidget {
  final List<Habit> habits;

  const ProgressChart({required this.habits, super.key});

  @override
  Widget build(BuildContext context) {
    // Create a map to store the count of completions (1 or 0) for each habit
    final Map<String, int> habitCompletionCounts = {};

    for (var habit in habits) {
      // Count the habit as 1 if completed, otherwise 0
      habitCompletionCounts[habit.title] = habit.isCompleted ? 1 : 0;
    }

    // Convert map to list of MapEntry
    final List<MapEntry<String, int>> dataEntries = habitCompletionCounts.entries.toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensures the column doesn't take up infinite height
        children: [
          const Text(
            'Habit Progress Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: SfCartesianChart(
              title: const ChartTitle(
                text: 'Habits Completion',
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              legend: const Legend(
                isVisible: true,
                overflowMode: LegendItemOverflowMode.wrap,
                position: LegendPosition.bottom,
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(
                  text: 'Habits',
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              primaryYAxis: const NumericAxis(
                minimum: 0,
                maximum: 2,
                interval: 1,
                title: AxisTitle(
                  text: 'Completion Status',
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              series: <CartesianSeries>[
                SplineAreaSeries<MapEntry<String, int>, String>(
                  dataSource: dataEntries,
                  xValueMapper: (MapEntry<String, int> entry, _) => entry.key,
                  yValueMapper: (MapEntry<String, int> entry, _) => entry.value,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.blueAccent,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
