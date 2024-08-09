import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  const HabitTile({required this.habit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    // Map to hold marking options
    final Map<String, Icon?> markingOptions = {
      'Red Flag': const Icon(Icons.flag, color: Colors.red),
      'Blue Flag': const Icon(Icons.flag, color: Colors.blue),
      'Green Flag': const Icon(Icons.flag, color: Colors.green),
      '1': const Icon(Icons.looks_one, color: Colors.red),
      '2': const Icon(Icons.looks_two, color: Colors.orange),
      '3': const Icon(Icons.looks_3, color: Colors.purple),
      '4': const Icon(Icons.looks_4, color: Colors.blue),
      '5': const Icon(Icons.looks_5, color: Colors.green),
      'Clear': const Icon(Icons.clear, color: Colors.grey),
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          // Circular button to mark habit as complete
          GestureDetector(
            onTap: () {
              habitProvider.toggleHabitCompletion(habit); // Toggle completion
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: habit.isCompleted
                  ? const Icon(
                Icons.check,
                color: Colors.green,
                size: 16,
              )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          // Habit title, date, and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  habit.scheduleDateTime(context), // Display scheduled date and time
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Enable Reminder Button
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.grey),
            onPressed: () {
              // Handle enabling reminder
              // (You can add your own logic to manage reminders)
            },
          ),
          // Mark with Symbol button
          PopupMenuButton<String>(
            icon: habit.symbol ?? const Icon(Icons.flag_outlined, color: Colors.grey),
            onSelected: (String value) {
              Icon? selectedIcon;
              if (value == 'Clear') {
                selectedIcon = const Icon(Icons.flag_outlined, color: Colors.grey);
              } else {
                selectedIcon = markingOptions[value];
              }

              // Update the habit with the selected marking icon
              final updatedHabit = habit.copyWith(symbol: selectedIcon);
              habitProvider.updateHabit(updatedHabit);
            },
            itemBuilder: (BuildContext context) {
              return markingOptions.keys.map((String key) {
                return PopupMenuItem<String>(
                  value: key,
                  child: Row(
                    children: [
                      markingOptions[key]!,
                      const SizedBox(width: 8),
                      Text(key),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}
