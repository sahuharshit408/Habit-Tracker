import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    final completedTasks = habitProvider.habits.where((habit) => habit.isCompleted).length;
    final pendingTasks = habitProvider.habits.length - completedTasks;

    final weeklyData = List.generate(7, (index) {
      final day = DateTime.now().subtract(Duration(days: DateTime.now().weekday - index));
      final dailyHabits = habitProvider.habits.where((habit) => habit.scheduledDate != null && isSameDay(habit.scheduledDate!, day));
      final completedCount = dailyHabits.where((habit) => habit.isCompleted).length;
      return ChartData(day.weekday.toString(), completedCount.toDouble());
    });

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
      backgroundColor: const Color(0xFF2E2E2E),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: habitProvider.habits.isEmpty
            ? const Center(
          child: Text(
            'No habits to show statistics for!',
            style: TextStyle(color: Colors.white),
          ),
        )
            : SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  _buildTaskCard('Completed Tasks', completedTasks.toString(), Colors.blue),
                  const SizedBox(width: 10),
                  _buildTaskCard('Pending Tasks', pendingTasks.toString(), Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              _buildTaskCompletionChart(weeklyData),
              const SizedBox(height: 20),
              _buildSectionHeader('Tasks in Next 7 Days'),
              const SizedBox(height: 10),
              _buildPendingTasksChart(donutChartData),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
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

  Widget _buildTaskCompletionChart(List<ChartData> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
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


  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const Spacer(),
        const Icon(Icons.info_outline, color: Colors.white),
      ],
    );
  }

  Widget _buildPendingTasksChart(List<ChartData> data) {
    final categoryColors = {
      'Work': Colors.blue,
      'Personal': Colors.green,
      'Professional': Colors.orange,
      'Others': Colors.grey,
      'No category': Colors.purple,
      'Reminder': Colors.red,
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
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

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
