import 'package:fit_app/workout-tracker/data_structures/sets/exercise_description.dart';

import '../../database/database.dart';
import 'adjustable_workout.dart';

class FutureWorkout implements AdjustableWorkout {
  int? _id;
  String name;
  final List<ExerciseDescription> _sets;
  String description;

  FutureWorkout()
      : _sets = [],
        name = "Untitled Workout",
        description = "";

  FutureWorkout.fromDatabase(
      {required int id,
      required String? name,
      required List<ExerciseDescription> sets,
      required String? description})
      : _id = id,
        _sets = sets,
        name = name ?? "Untitled Workout",
        description = description ?? "";

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
      'name': name,
      'description': description,
    };
  }

  void save() async {
    DatabaseManager dbm = DatabaseManager();

    if (_id != null) {
      dbm.deleteSavedWorkout(_id!);
      dbm.insertSavedWorkout(this);
    } else {
      _id = await dbm.insertSavedWorkout(this);
    }

    for (int i = 0; i < _sets.length; i++) {
      dbm.insertSavedExercise(_id!, _sets[i].name, i);
    }
  }
}
