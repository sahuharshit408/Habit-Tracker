import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/custom_calendar.dart';
import '../widgets/progress_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // For charts

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: habitProvider.habits.isEmpty
            ? const Center(
          child: Text('No habits to show statistics for!'),
        )
            : SingleChildScrollView( // Make the entire screen scrollable
          child: Column(
            children: [
              // Row for Completed and Pending Tasks
              Row(
                children: [
                  _buildTaskCard('Completed Tasks', '10', Colors.blue),
                  const SizedBox(width: 10),
                  _buildTaskCard('Pending Tasks', '1', Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              // Line Chart for Task Completion
              _buildTaskCompletionChart(),
              const SizedBox(height: 20),
              // Section for Tasks in Next 7 Days
              _buildSectionHeader('Tasks in Next 7 Days'),
              const SizedBox(height: 10),
              // Donut Chart for Pending Tasks in Categories
              _buildPendingTasksChart(),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build Task Cards
  Widget _buildTaskCard(String title, String count, Color color) {
    return Expanded(
      child: Card(
        color: Colors.grey[850],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build Task Completion Line Chart
  Widget _buildTaskCompletionChart() {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          title: const ChartTitle(
            text: 'Completion of Daily Tasks',
            textStyle: TextStyle(color: Colors.white),
          ),
          legend: const Legend(isVisible: false),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            LineSeries<ChartData, String>(
              dataSource: [
                ChartData('Sun', 0),
                ChartData('Mon', 0),
                ChartData('Tue', 0),
                ChartData('Wed', 0),
                ChartData('Thu', 0),
                ChartData('Fri', 0),
                ChartData('Sat', 0),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }

  // Method to build Section Header
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const Spacer(),
        const Icon(Icons.info_outline, color: Colors.black),
      ],
    );
  }

  // Method to build Pending Tasks Donut Chart
  Widget _buildPendingTasksChart() {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCircularChart(
          title: const ChartTitle(
              text: 'Pending Tasks in Categories',
              textStyle: TextStyle(color: Colors.white)),
          legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              textStyle: TextStyle(color: Colors.white)),
          series: <CircularSeries>[
            DoughnutSeries<ChartData, String>(
              dataSource: [
                ChartData('No Category', 1),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              pointColorMapper: (ChartData data, _) => Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}

// Sample data class for chart
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
