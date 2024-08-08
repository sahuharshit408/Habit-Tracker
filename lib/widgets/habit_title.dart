import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../screens/add_edit_habit_screen.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  const HabitTile({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

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
                  habit.scheduleDateTime(), // Display scheduled date and time
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Flag icon
          IconButton(
            icon: const Icon(Icons.flag_outlined, color: Colors.grey),
            onPressed: () {
              // Handle flag action
            },
          ),
        ],
      ),
    );
  }
}
