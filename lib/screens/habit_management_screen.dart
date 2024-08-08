import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_title.dart';
import 'add_edit_habit_screen.dart';

class HabitManagementScreen extends StatelessWidget {
  const HabitManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      body: habitProvider.habits.isEmpty
          ? const Center(
        child: Text('No habits added yet!'),
      )
          : ListView.builder(
        itemCount: habitProvider.habits.length,
        itemBuilder: (context, index) {
          final habit = habitProvider.habits[index];
          return HabitTile(habit: habit);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditHabitScreen()),
          );
        },
        tooltip: 'Add Habit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
