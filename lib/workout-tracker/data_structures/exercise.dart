import 'exercise_description.dart';
import 'exercise_set.dart';

abstract class Exercise {
  List<void> get sets;
  ExerciseDescription get description;
}

class LiveExercise extends Exercise {
  final ExerciseDescription _exerciseDescription;
  List<LiveAction> _sets = [];
  late int _position;
  late int _workoutID;

  LiveExercise(this._exerciseDescription,
      [List<LiveAction> sets =
          const []]); //TODO: when more advanced, we will change this to not init empty

  bool finished(int position, int workoutID) {
    _position = position;
    _workoutID = workoutID;
    _sets.removeWhere((element) => !element.isComplete);
    return sets.isNotEmpty;
  }

  bool get isPartiallyFinished =>
      _sets.isNotEmpty ? _sets.first.isComplete : false;

  @override
  ExerciseDescription get description {
    return _exerciseDescription;
  }

  @override
  List<LiveAction> get sets => _sets;

  void addSet() {
    if (description.exerciseType == "strength") {
      if (_sets.isNotEmpty) {
        _sets.add(
          LiveSet(
            weight: (_sets.last as LiveSet).weight,
            reps: (_sets.last as LiveSet).reps,
            restTime: (_sets.last as LiveSet).restTime,
          ),
        );
      } else {
        _sets.add(
          LiveSet(
            //TODO CHANGE THESE PARAMETERS TO LAST TIME'S
            weight: 0,
            reps: 0,
            restTime: 0,
          ),
        );
      }
    } else if (description.exerciseType == "cardio") {
      if (_sets.isNotEmpty) {
        _sets.add(
          LiveCardio(
            restTime: (_sets.last as LiveCardio).restTime,
            distance: (_sets.last as LiveCardio).distance,
            duration: (_sets.last as LiveCardio).duration,
          ),
        );
      } else {
        _sets.add(
          LiveCardio(
            //TODO CHANGE THESE PARAMETERS TO LAST TIME'S
            restTime: 0,
            distance: 0,
            duration: 0,
          ),
        );
      }
    }
  }

  void deleteSet(int position) => _sets.removeAt(position);

  Map<String, dynamic> toMap() {
    return {
      'workout_id': _workoutID,
      'position': _position,
      'description_id': _exerciseDescription.id,
    };
  }
}

class HistoricExercise implements Exercise {
  final ExerciseDescription _exerciseDescription;
  final List<HistoricAction> _sets;
  final int _position;

  HistoricExercise({
    required int position,
    required List<HistoricAction> sets,
    required ExerciseDescription description,
  })  : _position = position,
        _exerciseDescription = description,
        _sets = sets;

  @override
  ExerciseDescription get description => _exerciseDescription;
  @override
  List<HistoricAction> get sets => _sets;
}
