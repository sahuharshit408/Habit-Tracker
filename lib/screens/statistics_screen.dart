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

    // Calculate completed and pending tasks
    final completedTasks = habitProvider.habits.where((habit) => habit.isCompleted).length;
    final pendingTasks = habitProvider.habits.length - completedTasks;

    // Aggregate data for the task completion chart
    final weeklyData = List.generate(7, (index) {
      final day = DateTime.now().subtract(Duration(days: DateTime.now().weekday - index));
      final dailyHabits = habitProvider.habits.where((habit) => habit.scheduledDate != null && isSameDay(habit.scheduledDate!, day));
      final completedCount = dailyHabits.where((habit) => habit.isCompleted).length;
      return ChartData(day.weekday.toString(), completedCount.toDouble());
    });

    // Aggregate data for the pending tasks chart
    final categoryData = habitProvider.habits.fold<Map<String, int>>({}, (map, habit) {
      final category = habit.category.isNotEmpty ? habit.category : 'Uncategorized';
      if (!habit.isCompleted) {
        map[category] = (map[category] ?? 0) + 1;
      }
      return map;
    });

    final donutChartData = categoryData.entries
        .map((entry) => ChartData(entry.key, entry.value.toDouble()))
        .toList();

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
                  _buildTaskCard('Completed Tasks', completedTasks.toString(), Colors.blue),
                  const SizedBox(width: 10),
                  _buildTaskCard('Pending Tasks', pendingTasks.toString(), Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              // Line Chart for Task Completion
              _buildTaskCompletionChart(weeklyData),
              const SizedBox(height: 20),
              // Section for Tasks in Next 7 Days
              _buildSectionHeader('Tasks in Next 7 Days'),
              const SizedBox(height: 10),
              // Donut Chart for Pending Tasks in Categories
              _buildPendingTasksChart(donutChartData),
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
  Widget _buildTaskCompletionChart(List<ChartData> data) {
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
              dataSource: data,
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
  Widget _buildPendingTasksChart(List<ChartData> data) {
    // Define a map to assign colors to each category
    final categoryColors = {
      'Work': Colors.blue,
      'Personal': Colors.green,
      'Professional': Colors.orange,
      'Others': Colors.grey,
      'No category': Colors.purple,
      'Reminder': Colors.red,
    };

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
              dataSource: data,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              pointColorMapper: (ChartData data, _) => categoryColors[data.x] ?? Colors.blueAccent, // Use the map to get colors
            )
          ],
        ),
      ),
    );
  }

  // Helper method to check if two dates are on the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}

// Sample data class for chart
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
