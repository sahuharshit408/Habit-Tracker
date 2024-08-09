import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/habit.dart';

class CustomCalendar extends StatelessWidget {
  final List<Habit> habits;
  final Function(DateTime selectedDay, DateTime focusedDay)? onDaySelected;
  final bool Function(DateTime day)? selectedDayPredicate;

  const CustomCalendar({
    required this.habits,
    this.onDaySelected,
    this.selectedDayPredicate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      dataSource: HabitDataSource(habits),
      onTap: (CalendarTapDetails details) {
        if (details.date != null) {
          DateTime selectedDate = details.date!;
          DateTime focusedDate = details.date!;
          if (onDaySelected != null) {
            onDaySelected!(selectedDate, focusedDate);
          }
        }
      },
      monthCellBuilder: (BuildContext context, MonthCellDetails details) {
        int taskCount = _getTaskCountForDate(details.date);
        final bool isSelected = selectedDayPredicate != null
            ? selectedDayPredicate!(details.date)
            : false;

        double circleRadius = _getCircleRadius(taskCount);
        Color circleColor = isSelected ? Colors.blueAccent : Colors.teal;

        return Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: circleRadius,
                height: circleRadius,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                details.date.day.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
      headerStyle: const CalendarHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  int _getTaskCountForDate(DateTime date) {
    return habits
        .where((habit) => habit.scheduledDate != null && isSameDay(habit.scheduledDate!, date))
        .length;
  }

  double _getCircleRadius(int taskCount) {
    if (taskCount == 0) return 0.0;
    if (taskCount == 1) return 30.0;
    if (taskCount == 2) return 40.0;
    return 50.0 + (taskCount - 2) * 10.0;
  }
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

class HabitDataSource extends CalendarDataSource {
  HabitDataSource(List<Habit> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    final habit = appointments![index] as Habit;
    return habit.completedDates.isEmpty
        ? DateTime.now()
        : habit.completedDates.first;
  }

  @override
  DateTime getEndTime(int index) {
    final habit = appointments![index] as Habit;
    return habit.completedDates.isEmpty
        ? DateTime.now()
        : habit.completedDates.last;
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
