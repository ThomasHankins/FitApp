import 'package:fit_app/workout-tracker/file_manager.dart';
import 'exercise_set.dart';
import 'exercise_description.dart';

abstract class Exercise{

}
class LiveExercise extends Exercise {
  final int _id;
  final int _workoutID;
  final ExerciseDescription _exerciseDescription;
  List<ExerciseSet> sets = [];

  void giveSetsID() async {
    int i = 0;
    for (ExerciseSet exSet in sets) {
      exSet.position = i;
      i++;
    }
  }

  Exercise(
      {required int workoutID,
      required ExerciseDescription description})
      : _id = DatabaseManager().exerciseID,
        _workoutID = workoutID,
        _exerciseDescription = description;

  Exercise.blank(
      {required int workoutID, required ExerciseDescription description})
      : _id = DatabaseManager().exerciseID,
        _workoutID = workoutID,
        _exerciseDescription = description;

  Exercise.fromDatabase(
      {required int id,
      required int workoutID,
      required ExerciseDescription exerciseDescription,
      required int descriptionID,
      required this.sets})
      : _id = id,
        _workoutID = workoutID,
        _exerciseDescription = exerciseDescription;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'workout_id': _workoutID,
      'description_id': _exerciseDescription.getID,
    };
  }

  @override
  String toString() {
    int desID = _exerciseDescription.getID;
    return 'Exercise(id: $_id, workout_id: $_workoutID, description_id: $desID)';
  }

  get id {
    return _id;
  }

  bool get isAllDone {
    if (sets.isEmpty) {
      return false;
    }
    for (ExerciseSet exSet in sets) {
      if (exSet._complete == false) {
        return false;
      }
    }
    return true;
  }

  ExerciseDescription get description {
    return _exerciseDescription;
  }
}

class HistoricExercise implements Exercise {}

