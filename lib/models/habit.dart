import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class Habit {
  final String id; // Unique identifier
  final String title;
  final String description;
  final List<DateTime> completedDates; // Completed dates property
  bool isCompleted; // Completion status

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.completedDates,
    this.isCompleted = false,
  });

  // Factory constructor to create a Habit from a map
  factory Habit.fromMap(Map<String, dynamic> data) {
    return Habit(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      completedDates: List<DateTime>.from(
          (data['completedDates'] as List<dynamic>?)?.map((date) => DateTime.parse(date)) ?? []
      ),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  // Method to convert a Habit to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
      'isCompleted': isCompleted,
    };
  }

  // Method to format and return scheduled date and time
  String scheduleDateTime() {
    if (completedDates.isNotEmpty) {
      DateTime lastDate = completedDates.last;
      return DateFormat('MM-dd hh:mm a').format(lastDate); // Formatting date and time
    }
    return 'No schedule'; // Default if no dates
  }

  // Method to toggle habit completion status
  void toggleCompletion() {
    isCompleted = !isCompleted;
  }
}
