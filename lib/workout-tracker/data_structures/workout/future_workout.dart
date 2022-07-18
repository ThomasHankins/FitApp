import 'package:fit_app/workout-tracker/data_structures/sets/exercise_description.dart';

import '../../file_manager.dart';
import 'adjustable_workout.dart';

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
