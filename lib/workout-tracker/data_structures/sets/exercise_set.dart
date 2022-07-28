import 'package:fit_app/workout-tracker/data_structures/structures.dart';

import 'details/details.dart';
// import 'package:objectbox/objectbox.dart';

class ExerciseSet {
  SetDetails details;
  final ExerciseDescription _description;
  final int _workoutId;
  late final int _time;
  late final int _position;

  bool _complete = false;
  bool get isComplete => _complete;

  void complete(int timestamp, int position) {
    _complete = true;
    _time = timestamp;
    _position = position;
  }

  ExerciseSet(
      {required this.details,
      required ExerciseDescription description,
      required int workoutId})
      : _description = description,
        _workoutId = workoutId;

  get description => _description;

  Map<String, dynamic> toMap() {
    //TODO verify correctness
    return {
      'workout_id': _workoutId,
      'position': _position,
      'time_marker': _time,
    };
  }
}
