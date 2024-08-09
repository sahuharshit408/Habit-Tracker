import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final List<DateTime> completedDates;
  bool isCompleted;
  final DateTime? scheduledDate;
  late final TimeOfDay? reminderTime;
  final String repeatFrequency;
  late final String category;
  final Icon? symbol;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.completedDates,
    this.isCompleted = false,
    this.scheduledDate,
    this.reminderTime,
    this.repeatFrequency = 'None',
    this.category = 'Others',
    this.symbol,
  });

  factory Habit.fromMap(Map<String, dynamic> data) {
    return Habit(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      completedDates: List<DateTime>.from(
          (data['completedDates'] as List<dynamic>?)?.map((date) => DateTime.parse(date)) ?? []
      ),
      isCompleted: data['isCompleted'] ?? false,
      scheduledDate: data['scheduledDate'] != null ? DateTime.parse(data['scheduledDate']) : null,
      reminderTime: data['reminderTime'] != null ? TimeOfDay(
          hour: int.parse(data['reminderTime'].split(':')[0]),
          minute: int.parse(data['reminderTime'].split(':')[1])
      ) : null,
      repeatFrequency: data['repeatFrequency'] ?? 'None',
      category: data['category'] ?? 'Uncategorized', // Handle category
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
      'isCompleted': isCompleted,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'reminderTime': reminderTime != null
          ? '${reminderTime!.hour}:${reminderTime!.minute}'
          : null,
      'repeatFrequency': repeatFrequency,
      'category': category,
    };
  }

  String scheduleDateTime(BuildContext context) {
    if (scheduledDate != null) {
      String day = DateFormat('d').format(scheduledDate!);
      String month = DateFormat('MMM').format(scheduledDate!);
      String time = reminderTime != null ? reminderTime!.format(context) : 'No time';

      return '$day $month - $time';
    }
    return 'No schedule';
  }

  void toggleCompletion() {
    isCompleted = !isCompleted;
  }

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    List<DateTime>? completedDates,
    DateTime? scheduledDate,
    TimeOfDay? reminderTime,
    String? repeatFrequency,
    String? category,
    Icon? symbol,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completedDates: completedDates ?? this.completedDates,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      reminderTime: reminderTime ?? this.reminderTime,
      repeatFrequency: repeatFrequency ?? this.repeatFrequency,
      category: category ?? this.category,
      symbol: symbol ?? this.symbol,
    );
  }
}
