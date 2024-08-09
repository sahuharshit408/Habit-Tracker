import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = []; // List to store habits
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  HabitProvider() {
    _initializeUser();
  }

  void _initializeUser() {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _fetchHabits();
    } else {
      print('User is not logged in');
    }
  }

  List<Habit> get habits => _habits; // Getter for habits

  // Method to fetch habits from Firestore
  Future<void> _fetchHabits() async {
    if (_user == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_user!.email)
          .collection('habits')
          .get();

      _habits.clear();
      for (var doc in snapshot.docs) {
        _habits.add(Habit.fromMap(doc.data()));
      }
      notifyListeners(); // Notify listeners to rebuild UI
    } catch (e) {
      print('Error fetching habits: $e');
    }
  }

  // Method to add a new habit
  Future<void> addHabit(Habit habit) async {
    if (_user == null) return;

    _habits.add(habit);
    notifyListeners(); // Notify listeners to rebuild UI

    try {
      await _firestore
          .collection('users')
          .doc(_user!.email)
          .collection('habits')
          .doc(habit.id)
          .set(habit.toMap());
    } catch (e) {
      print('Error adding habit: $e');
    }
  }

  // Method to delete a habit
  Future<void> deleteHabit(Habit habit) async {
    if (_user == null) return;

    _habits.remove(habit);
    notifyListeners(); // Notify listeners to rebuild UI

    try {
      await _firestore
          .collection('users')
          .doc(_user!.email)
          .collection('habits')
          .doc(habit.id)
          .delete();
    } catch (e) {
      print('Error deleting habit: $e');
    }
  }

  // Method to update a habit
  Future<void> updateHabit(Habit habit) async {
    if (_user == null) return;

    int index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners(); // Notify listeners to rebuild UI

      try {
        await _firestore
            .collection('users')
            .doc(_user!.email)
            .collection('habits')
            .doc(habit.id)
            .set(habit.toMap());
      } catch (e) {
        print('Error updating habit: $e');
      }
    }
  }

  // Method to toggle habit completion
  Future<void> toggleHabitCompletion(Habit habit) async {
    habit.toggleCompletion();
    await updateHabit(habit); // Update the habit in the list
  }
}
