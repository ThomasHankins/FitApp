import 'package:fit_app/workout-tracker/data_structures/set_builder.dart';
import 'package:intl/intl.dart';

import '../file_manager.dart';
import 'structures.dart';

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

  void loadNextID() async {
    /*not really the best solution to asynchronously load the id
    it would be better to defer the creation of the object with a private constructor that is called by a public async method
     */
    _id = await DatabaseManager().nextWorkoutID;
  }

  LiveWorkout()
      : _name =
            DateFormat.yMMMMd('en_us').format(DateTime.now()) + " - Workout",
        _exercises = [],
        timer = Stopwatch() {
    loadNextID();
  }

  LiveWorkout.convertFromSaved(FutureWorkout fw)
      : _name = fw.name,
        _exercises = [],
        timer = Stopwatch() {
    loadNextID();
    for (ExerciseDescription exercise in fw.exercises) {
      _exercises.add(LiveExercise(exercise,
          HistoricSetBuilder())); //in the future I would like this to have different options in the settings screen
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

  bool get hasStarted {
    if (_exercises.isEmpty) return false;
    for (LiveExercise exercise in _exercises) {
      if (exercise.isPartiallyFinished) return true;
    }
    return false;
  }

  @override
  void deleteExercise(int position) => _exercises.removeAt(position);
  @override
  void addExercise(ExerciseDescription desc, [int? position]) =>
      _exercises.insert(position ?? _exercises.length,
          LiveExercise(desc, HistoricSetBuilder()));
  @override
  void reorderExercises(int oldPosition, int newPosition) {
    if (!_exercises[oldPosition].isPartiallyFinished &&
        !_exercises[newPosition].isPartiallyFinished) {
      _exercises.insert(newPosition, _exercises.removeAt(oldPosition));
    }
  }

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
    timer.stop();

    _exercises.removeWhere(
        (element) => !element.finished(_exercises.indexOf(element), _id));

    if (exercises.isNotEmpty) {
      DatabaseManager dbm = DatabaseManager();
      dbm.insertHistoricWorkout(this);

      for (int i = 0; i < _exercises.length; i++) {
        dbm.insertHistoricExercise(_exercises[i]);
        for (int j = 0; j < _exercises[i].sets.length; j++) {
          if (_exercises[i].description.exerciseType == "strength") {
            dbm.insertHistoricSet(_exercises[i].sets[j] as LiveSet);
          } else if (_exercises[i].description.exerciseType == "cardio") {
            dbm.insertHistoricCardio(_exercises[i].sets[j] as LiveCardio);
          }
        }
      }
    }
  }
}

class FutureWorkout implements AdjustableWorkout {
  late final int _id;
  String _name;
  final List<ExerciseDescription> _exercises;
  String _description;

  FutureWorkout()
      : _exercises = [],
        _name = "Untitled Workout",
        _description = "" {
    loadNextID();
  }

  void loadNextID() async {
    _id = await DatabaseManager().nextSavedWorkoutID;
  }

  FutureWorkout.fromDatabase(
      {required int id,
      required String? name,
      required List<ExerciseDescription> exercises,
      required String? description})
      : _id = id,
        _exercises = exercises,
        _name = name ?? "Untitled Workout",
        _description = description ?? "";

  @override
  int get id => _id;
  @override
  String get name => _name;
  @override
  List<ExerciseDescription> get exercises => _exercises;
  String get description => _description;

  @override
  set name(String nm) => _name = nm;
  set description(String desc) => _description = desc;

  @override
  void deleteExercise(int position) => _exercises.removeAt(position);
  @override
  void addExercise(ExerciseDescription desc, [int? position]) =>
      _exercises.insert(position ?? _exercises.length, desc);
  @override
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
    DatabaseManager dbm = DatabaseManager();
    try {
      dbm.deleteSavedWorkout(_id);
    } catch (e) {
      //no issue just means this isn't new
    }
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
        _length = length;

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
