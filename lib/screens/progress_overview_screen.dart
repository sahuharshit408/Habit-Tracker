import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart' as table_calendar;
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../widgets/progress_chart.dart';
import '../widgets/custom_calendar.dart' as custom_calendar;

class ProgressOverviewScreen extends StatefulWidget {
  const ProgressOverviewScreen({super.key});

  @override
  _ProgressOverviewScreenState createState() => _ProgressOverviewScreenState();
}

class _ProgressOverviewScreenState extends State<ProgressOverviewScreen> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    // Filter habits based on the selected day
    List<Habit> habitsForSelectedDay = habitProvider.habits
        .where((habit) => habit.scheduledDate != null && table_calendar.isSameDay(habit.scheduledDate!, _selectedDay))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E), // Greyish background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Custom Calendar with black background container
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black, // Black container color
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: custom_calendar.CustomCalendar(
                  habits: habitProvider.habits,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return table_calendar.isSameDay(_selectedDay, day);
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              // Habit List
              habitsForSelectedDay.isEmpty
                  ? Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black, // Black container color
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'No habits scheduled for this day!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
                  : Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Black container color
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling of ListView
                  shrinkWrap: true, // Make ListView take only the necessary space
                  itemCount: habitsForSelectedDay.length,
                  itemBuilder: (context, index) {
                    final habit = habitsForSelectedDay[index];
                    return ListTile(
                      title: Text(
                        habit.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        habit.description,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: habit.isCompleted
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              // Progress Chart with black background container
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black, // Black container color
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ProgressChart(habits: habitProvider.habits),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
