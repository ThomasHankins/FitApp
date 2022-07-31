import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:fit_app/workout-tracker/data_structures/workout/historic_workout.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final List<HistoricWorkout> history;
  const CalendarWidget({Key? key, required this.history}) : super(key: key);
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  List<HistoricWorkout> _getEventsForDay(DateTime day) {
    return widget.history.where((element) => element.date == day).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(
          2022, 1, 1), //in the future make this relative to the first workout
      lastDay: DateTime.now().add(const Duration(days: 31)),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.week,
      weekendDays: const [],
      startingDayOfWeek: StartingDayOfWeek.values[DateTime.now().weekday - 7],
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      eventLoader: (day) {
        return _getEventsForDay(day);
      },
    );
  }
}
