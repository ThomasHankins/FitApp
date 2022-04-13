import 'dart:async';

import 'package:intl/intl.dart';

import 'exercise.dart';
import 'file_manager.dart';

class Workout {
  final int _id;
  String name;
  List<Exercise> exercises;
  DateTime date;
  Stopwatch? timer; //init  Stopwatch() later
  int length = 0;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': name,
      'date': date.toIso8601String(),
      'length': length,
    };
  }

  @override
  String toString() {
    //can remove later if necessary
    return 'Workout{id: $_id, name: $name, date: $date.toIso8601String(), length: $length)';
  }

  int get getID {
    return _id.toInt();
  }

  Workout.fromHistoric(
      {required int oldID,
      required List<Exercise> oldExercises,
      required String oldName,
      required String oldDate,
      required int oldLength})
      : _id = oldID,
        exercises = oldExercises,
        name = oldName,
        date = DateTime.parse(oldDate),
        length = oldLength;

  Workout.fromEmpty()
      : _id = DatabaseManager().workoutID,
        date = DateTime.now(),
        name = DateFormat.yMMMMd('en_us').format(DateTime.now()) + " - Workout",
        exercises = [],
        length = 0,
        timer = Stopwatch();

  Future<void> endWorkout() async {
    for (Exercise exercise in exercises) {
      exercise.sets.removeWhere((element) => !element.isComplete);
    }

    exercises.removeWhere((element) => element.sets.isEmpty);
    timer?.stop();
    int? tempLength = timer?.elapsed.inSeconds;
    tempLength ??= -1;
    length = tempLength;

    for (Exercise exercise in exercises) {
      exercise.giveSetsID();
    }

    if (exercises.isNotEmpty) {
      DatabaseManager().insertWorkout(this);
    }
  }
}
