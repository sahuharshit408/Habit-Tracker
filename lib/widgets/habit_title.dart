import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  const HabitTile({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

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
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              habitProvider.toggleHabitCompletion(habit);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                color: habit.isCompleted ? Colors.green : Colors.transparent,
              ),
              child: habit.isCompleted
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
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
                  habit.scheduleDateTime(context),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.grey),
            onPressed: () {
              //to add notifications
            },
          ),
          PopupMenuButton<String>(
            icon: habit.symbol ?? const Icon(Icons.flag_outlined, color: Colors.grey),
            color: Colors.grey[850], // Background color of the PopupMenu
            onSelected: (String value) {
              Icon? selectedIcon;
              if (value == 'Clear') {
                selectedIcon = const Icon(Icons.flag_outlined, color: Colors.grey);
              } else {
                selectedIcon = markingOptions[value];
              }
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
                      Text(key, style: const TextStyle(color: Colors.white)), // Item text color
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
