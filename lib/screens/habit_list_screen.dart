import 'package:flutter/material.dart';

class HabitListScreen extends StatelessWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'This is the Habit List Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
