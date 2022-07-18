import 'package:fit_app/workout-tracker/data_structures/sets/live_set.dart';
import 'package:intl/intl.dart';

import '../../file_manager.dart';
import '../structures.dart';
import 'adjustable_workout.dart';
import 'future_workout.dart';

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
