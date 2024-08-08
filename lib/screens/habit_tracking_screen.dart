import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/habit.dart';

class HabitTrackingScreen extends StatelessWidget {
  final Habit habit;

  const HabitTrackingScreen({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.title),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: HabitDataSource(habit.completedDates),
      ),
    );
  }
}

class HabitDataSource extends CalendarDataSource {
  HabitDataSource(List<DateTime> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index];
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index];
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  @override
  String getSubject(int index) {
    return 'Completed';
  }
}
