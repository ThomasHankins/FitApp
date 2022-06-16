abstract class ExerciseSet {
  bool get isComplete => null;

}

class LiveSet implements ExerciseSet {
  final int _exerciseID;
  int? _position; //workout ID and position form primary key
  double _weight = 0;
  int _reps = 0;
  int _rpe = 10;
  String? _note = '';
  bool _inKG = false;
  bool _complete = false;

  ExerciseSet.fromDatabase(int exerciseID, int position, double weight,
      int reps, int rpe, String note, int inKG)
      : _exerciseID = exerciseID,
        _position = position,
        _weight = weight,
        _reps = reps,
        _rpe = rpe,
        _note = note,
        _inKG = (inKG == 1),
        _complete = true;

  ExerciseSet.fromBlank(this._exerciseID, [this._position]);

  Map<String, dynamic> toMap() {
    return {
      'exercise_id': _exerciseID,
      'position': _position,
      'weight': _weight,
      'reps': _reps,
      'RPE': _rpe,
      'note':
      _note, //TODO need data validation to ensure less than 30 characters
      'in_KG': _inKG ? 1 : 0,
    };
  }

  @override
  String toString() {
    //can remove later if necessary
    return 'Set(exercise_id: $_exerciseID, position: $_position, weight: $_weight, reps: $_reps, RPE: $_rpe, note: $_note, in_KG: $_inKG)'; //might want to add complete bool if necessary
  }

  set position(int pos) {
    _position = pos;
  }

  set selectWeight(double weightChosen) {
    _weight = weightChosen;
  }

  double get weight {
    return _weight;
  }

  set selectReps(int repsChosen) {
    _reps = repsChosen;
  }

  get reps {
    return _reps;
  }

  void completeSet() {
    _complete = true;
  }

  bool get isComplete {
    return _complete;
  }
}

class LiveCardio implements ExerciseSet {}

class HistoricSet implements ExerciseSet {
  toMap() {}
}

class HistoricCardio implements ExerciseSet{
  toMap() {}
}