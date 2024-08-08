import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = []; // List to store habits

  List<Habit> get habits => _habits; // Getter for habits

  // Method to add a new habit
  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Method to delete a habit
  void deleteHabit(Habit habit) {
    _habits.remove(habit);
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Method to update a habit
  void updateHabit(Habit habit) {
    int index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners(); // Notify listeners to rebuild UI
    }
  }

  // Method to toggle habit completion
  void toggleHabitCompletion(Habit habit) {
    habit.toggleCompletion();
    updateHabit(habit); // Update the habit in the list
  }
}
