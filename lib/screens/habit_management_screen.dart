import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_title.dart';
import 'add_edit_habit_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitManagementScreen extends StatelessWidget {
  const HabitManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E), // Greyish background
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF2E2E2E),
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text(
      //     'Manage Habits',
      //     style: GoogleFonts.poppins(
      //       textStyle: const TextStyle(
      //         fontSize: 24,
      //         fontWeight: FontWeight.w600,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),
      body: habitProvider.habits.isEmpty
          ? Center(
        child: Text(
          'No habits added yet!',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ),
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
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
