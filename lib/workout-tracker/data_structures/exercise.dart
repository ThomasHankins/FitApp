import 'package:fit_app/workout-tracker/file_manager.dart';
import 'exercise_set.dart';
import 'exercise_description.dart';

abstract class Exercise{
  List<void> get sets;
  ExerciseDescription get description;

}
class LiveExercise extends Exercise {
  final ExerciseDescription _exerciseDescription;
  List<LiveAction> _sets;

  LiveExercise(
      this._exerciseDescription, [this._sets = const []]); //TODO: when more advanced, we will change this to not init empty


  bool get finished {
    _sets.removeWhere((element) => !element.isComplete);
    return sets.isNotEmpty;
  }


  @override
  ExerciseDescription get description {
    return _exerciseDescription;
  }
  @override
  List<LiveAction> get sets => _sets;

  void addAction()=> (_sets.last is LiveSet) ? _sets.add(LiveSet()) : _sets.add(LiveCardio()); //TODO need to find a way to get values from the last set
  void deleteAction(int position) => _sets.removeAt(position);

}

class HistoricExercise implements Exercise {
  final ExerciseDescription _exerciseDescription;
  final List<HistoricAction> _sets;
  final int _position;

  HistoricExercise({required int position, required List<HistoricAction> sets, required ExerciseDescription description,}):
      _position = position,
      _exerciseDescription = description,
      _sets = sets;

  @override
  ExerciseDescription get description => _exerciseDescription;
  @override
  List<HistoricAction> get sets => _sets;

  }

}

