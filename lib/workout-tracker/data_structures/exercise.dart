import 'exercise_description.dart';
import 'exercise_set.dart';

abstract class Exercise {
  List<void> get sets;
  ExerciseDescription get description;
}

class LiveExercise extends Exercise {
  final ExerciseDescription _exerciseDescription;
  List<LiveAction> _sets;
  late int _position;
  late int _workoutID;

  LiveExercise(this._exerciseDescription,
      [this._sets =
          const []]); //TODO: when more advanced, we will change this to not init empty

  bool finished(int position, int workoutID) {
    _position = position;
    _workoutID = workoutID;
    _sets.removeWhere((element) => !element.isComplete);
    return sets.isNotEmpty;
  }

  @override
  ExerciseDescription get description {
    return _exerciseDescription;
  }

  @override
  List<LiveAction> get sets => _sets;

  //TODO need to find a way to get values from the last set
  //void addSet()=> (_sets.last is LiveSet) ? _sets.add(LiveSet()) : _sets.add(LiveCardio());

  void deleteSet(int position) => _sets.removeAt(position);

  Map<String, dynamic> toMap() {
    return {
      'workout_id': _workoutID,
      'position': _position,
      'description': _exerciseDescription.id,
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
