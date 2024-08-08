import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/habit.dart';

class CustomCalendar extends StatelessWidget {
  final List<Habit> habits;
  const CustomCalendar({required this.habits, super.key});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      dataSource: HabitDataSource(habits),
    );
  }
}

class HabitDataSource extends CalendarDataSource {
  HabitDataSource(List<Habit> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    final habit = appointments![index] as Habit;
    return habit.completedDates.isEmpty ? DateTime.now() : habit.completedDates.first;
  }

  @override
  DateTime getEndTime(int index) {
    final habit = appointments![index] as Habit;
    return habit.completedDates.isEmpty ? DateTime.now() : habit.completedDates.last;
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as Habit).title;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }
}
