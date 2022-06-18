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
}

abstract class AdjustableWorkout extends Workout {
  void addExercise(ExerciseDescription desc, [int? position]);
  void deleteExercise(int position);
  void reorderExercises(int oldPosition, int newPosition);
}

class LiveWorkout extends AdjustableWorkout {
  late final int _id;
  String _name;
  List<LiveExercise> _exercises;
  Stopwatch timer;

  LiveWorkout()
      : _name =
            DateFormat.yMMMMd('en_us').format(DateTime.now()) + " - Workout",
        _exercises = [],
        timer = Stopwatch() {
    loadNextID();
  }

  void loadNextID() async {
    _id = await DatabaseManager().nextWorkoutID();
  }

  LiveWorkout.convertFromSaved(FutureWorkout fw)
      : _id = DatabaseManager().nextWorkoutID(),
        _name = fw.name,
        _exercises = [],
        timer = Stopwatch() {
    for (ExerciseDescription exercise in fw.exercises) {
      _exercises.add(LiveExercise(exercise));
    }
  }

  @override
  int get id => _id;
  @override
  String get name => _name;
  @override
  List<LiveExercise> get exercises => _exercises;
  @override
  set name(String nm) => _name = nm;

  @override
  void deleteExercise(int position) => _exercises.removeAt(position);
  @override
  void addExercise(ExerciseDescription desc, [int? position]) =>
      _exercises.insert(position ?? _exercises.length, LiveExercise(desc));
  @override
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
    //todo, review once other data structures are complete
    timer.stop();

    _exercises.removeWhere(
        (element) => !element.finished(_id, _exercises.indexOf(element)));

    if (exercises.isNotEmpty) {
      DatabaseManager dbm = DatabaseManager();
      dbm.insertHistoricWorkout(this);

      for (LiveExercise exercise in _exercises) {
        //TODO implement
      }
    }
  }
}

class FutureWorkout implements AdjustableWorkout {
  late final int _id;
  String? _name;
  List<ExerciseDescription> _exercises;
  String? _description;

  FutureWorkout() : _exercises = [] {
    loadNextID();
  }

  void loadNextID() async {
    _id = await DatabaseManager().nextSavedWorkoutID;
  }

  FutureWorkout.fromDatabase(
      {required int id,
      required String name,
      required List<ExerciseDescription> exercises,
      required String? description})
      : _id = id,
        _name = name,
        _exercises = exercises,
        _description = description;

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

  @override
  void deleteExercise(int position) => _exercises.removeAt(position);
  @override
  void addExercise(ExerciseDescription desc, [int? position]) =>
      _exercises.insert(position ?? _exercises.length, desc);
  @override
  void reorderExercises(int oldPosition,
          int newPosition) => //TODO: make this immutable if a set has been completed in an exercise
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
    DatabaseManager dbm = DatabaseManager();

    dbm.insertSavedWorkout(this);
    for (int i = 0; i < _exercises.length; i++) {
      dbm.insertSavedExercise(_id, _exercises[i].id, i);
    }
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
      required List<HistoricExercise> exercises,
      required String date,
      required int length})
      : _id = id,
        _name = name,
        _exercises = exercises,
        _date = DateTime.parse(date),
        _length = length {
    //TODO add db query using WHERE id = _id to get the exercise list
  }

  @override
  int get id => _id;
  @override
  String get name => _name;
  @override
  List<HistoricExercise> get exercises => _exercises;
  @override
  set name(String nm) => _name = nm;
  DateTime get date => _date;
  int get length => _length;

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
