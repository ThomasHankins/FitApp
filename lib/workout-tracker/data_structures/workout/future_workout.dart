import 'package:fit_app/workout-tracker/data_structures/sets/exercise_description.dart';

import '../../database/database.dart';
import 'adjustable_workout.dart';

class FutureWorkout implements AdjustableWorkout {
  late final int _id;
  String name;
  final List<ExerciseDescription> _sets;
  String description;

  FutureWorkout()
      : _sets = [],
        name = "Untitled Workout",
        description = "" {
    loadNextID();
  }

  void loadNextID() async {
    _id = await DatabaseManager()
        .nextSavedWorkoutID; //TODO we'll redo this similar to the live workout later
  }

  FutureWorkout.fromDatabase(
      {required int id,
      required String? name,
      required List<ExerciseDescription> sets,
      required String? description})
      : _id = id,
        _sets = sets,
        name = name ?? "Untitled Workout",
        description = description ?? "";

  int get id => _id;

  List<ExerciseDescription> get sets => _sets;

  @override
  void deleteSet(int position) => _sets.removeAt(position);
  @override
  void addSet(ExerciseDescription desc, [int? position]) =>
      _sets.insert(position ?? _sets.length, desc);
  @override
  void reorderSet(int oldPosition, int newPosition) =>
      _sets.insert(newPosition, _sets.removeAt(oldPosition));

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': name,
      'description': description,
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
    for (int i = 0; i < _sets.length; i++) {
      dbm.insertSavedExercise(_id, _sets[i].id, i);
    }
  }
}
