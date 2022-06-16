import 'package:intl/intl.dart';

import '../file_manager.dart';
import 'exercise.dart';
import 'exercise_description.dart';

abstract class Workout {
  set name(String nm);

  int get id;
  String get name;
  List<void> get exercises;

  Map<String, dynamic> toMap();

  @override
  String toString();
}

class LiveWorkout extends Workout {
  final int _id;
  String _name;
  List<LiveExercise> _exercises;
  Stopwatch timer;

  LiveWorkout()
      : _id = DatabaseManager().nextWorkoutID(),
        _name =
            DateFormat.yMMMMd('en_us').format(DateTime.now()) + " - Workout",
        _exercises = [],
        timer = Stopwatch();

  LiveWorkout.convertFromSaved(FutureWorkout fw)
      : _id = DatabaseManager().nextWorkoutID(),
        _name = fw.name,
        _exercises = [],
        timer = Stopwatch() {
    for (ExerciseDescription exercise in fw.exercises) {
      _exercises.add(LiveExercise(workoutID: _id, description: exercise));
    }
  }

  @override
  int get id => _id;
  @override
  String get name => _name ?? "";
  @override
  List<LiveExercise> get exercises => _exercises;
  @override
  set name(String nm) => _name = nm;

  void deleteExercise(int position) => _exercises.removeAt(position);
  void addExercise(ExerciseDescription description, [int? position]) =>
      _exercises.insert(position ?? _exercises.length,
          LiveExercise(workoutID: _id, description: description));
  void reorderExercises(int oldPosition, int newPosition) =>
      _exercises.insert(newPosition, _exercises.removeAt(oldPosition));

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'date': DateTime.now().toIso8601String(),
      'length': timer.elapsed.inSeconds,
    };
  }

  void start() {
    timer.start();
  }

  Future<void> endWorkout() async {
    //todo, would be nice to review once other data strucutres are complete
    timer.stop();
    for (LiveExercise exercise in exercises) {
      exercise.sets.removeWhere((element) => !element.isComplete);
    }
    exercises.removeWhere((element) => element.sets.isEmpty);

    if (exercises.isNotEmpty) {
      DatabaseManager().insertHistoricWorkout(this);
      //TODO for excercise in exercises ... save to db
    }
  }
}

class FutureWorkout implements Workout {
  final int _id;
  String? _name;
  List<ExerciseDescription> _exercises;
  String? _description;

  FutureWorkout()
      : _id = DatabaseManager().nextSavedWorkoutID,
        _exercises = [];
  @override
  int get id => _id;
  @override
  String get name => _name ?? "";
  @override
  List<ExerciseDescription> get exercises => _exercises;
  String get description => _description ?? "";

  @override
  set name(String nm) => _name = nm;
  set description(String desc) => _description = desc;

  void deleteExercise(int position) => _exercises.removeAt(position);
  void addExercise(ExerciseDescription description, [int? position]) =>
      _exercises.insert(position ?? _exercises.length, description);
  void reorderExercises(int oldPosition, int newPosition) =>
      _exercises.insert(newPosition, _exercises.removeAt(oldPosition));

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'description': _description,
    };
  }

  void save() {
    // TODO: implement save - don't forget to save info on saved_workouts and saved_exercises
    throw UnimplementedError();
  }
}

class HistoricWorkout implements Workout {
  final int _id;
  String _name;
  final List<HistoricExercise> _exercises;
  final DateTime _date;
  final int _length;

  HistoricWorkout(
      {required int id,
      required String name,
      required String date,
      required int length})
      : _id = id,
        _name = name,
        _exercises = [],
        _date = DateTime.parse(date),
        _length = length {
    //TODO add db query using WHERE id = _id to get the exercise list
  }

  @override
  int get id => _id;
  @override
  String get name => _name ?? "";
  @override
  List<HistoricExercise> get exercises => _exercises;
  @override
  set name(String nm) => _name = nm;

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'date': _date.toIso8601String(),
      'length': _length,
    };
  }
}
