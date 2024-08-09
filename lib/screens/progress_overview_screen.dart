import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart' as table_calendar; // Prefixing the table_calendar import
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../widgets/progress_chart.dart';
import '../widgets/custom_calendar.dart' as custom_calendar; // Prefixing the custom_calendar import

class ProgressOverviewScreen extends StatefulWidget {
  const ProgressOverviewScreen({super.key});

  @override
  _ProgressOverviewScreenState createState() => _ProgressOverviewScreenState();
}

class _ProgressOverviewScreenState extends State<ProgressOverviewScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    // Filter habits based on the selected day
    List<Habit> habitsForSelectedDay = habitProvider.habits
        .where((habit) => habit.scheduledDate != null && table_calendar.isSameDay(habit.scheduledDate!, _selectedDay))
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              custom_calendar.CustomCalendar(
                habits: habitProvider.habits,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                selectedDayPredicate: (day) {
                  return table_calendar.isSameDay(_selectedDay, day);
                },
              ),
              const SizedBox(height: 20.0),
              habitsForSelectedDay.isEmpty
                  ? const Center(
                child: Text('No habits scheduled for this day!'),
              )
                  : ListView.builder(
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling of ListView
                shrinkWrap: true, // Make ListView take only the necessary space
                itemCount: habitsForSelectedDay.length,
                itemBuilder: (context, index) {
                  final habit = habitsForSelectedDay[index];
                  return ListTile(
                    title: Text(habit.title),
                    subtitle: Text(habit.description),
                    trailing: habit.isCompleted
                        ? const Icon(Icons.check_circle,
                        color: Colors.green)
                        : const Icon(Icons.radio_button_unchecked,
                        color: Colors.grey),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ProgressChart(habits: habitProvider.habits),
            ],
          ),
        ),
      ),
    );
  }
}
