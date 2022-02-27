class Exercise {
  late final int _id;
  final int _workoutID;
  final int _descriptionID;
  List<ExerciseSet> sets = [];

  Exercise(
      {required int workoutID, required int descriptionID, required this.sets})
      : _workoutID = workoutID,
        _descriptionID = descriptionID;

  Exercise.blank({required int workoutID, required int descriptionID})
      : _workoutID = workoutID,
        _descriptionID = descriptionID;

  Exercise.fromDatabase(
      {required int id,
      required int workoutID,
      required int descriptionID,
      required this.sets})
      : _id = id,
        _workoutID = workoutID,
        _descriptionID = descriptionID;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'workout_id': _workoutID,
      'description_id': _descriptionID,
    };
  }

  @override
  String toString() {
    return 'Exercise{id: $_id, workout_id: $_workoutID, description_id: $_descriptionID)';
  }

  set giveID(int id) {
    _id = id;
    int i = 0;
    for (ExerciseSet exSet in sets) {
      exSet.position = i;
      i++;
    }
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
}

class ExerciseDescription {
  final int? _id; //TODO make non nullable
  final String? _name;
  final String? _description;
  final String? _muscleGroup;
  bool _isCompound = false;
  bool _isMachine = false;

  ExerciseDescription(int compound, int machine,
      [this._id, this._name, this._description, this._muscleGroup]) {
    _isCompound = (compound == 0) ? false : true;
    _isMachine = (machine == 0) ? false : true;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'description': _description,
      'muscle_group': _muscleGroup,
      'is_compound': _isCompound ? 1 : 0,
      'is_machine': _isMachine ? 1 : 0,
    };
  }

  @override
  String toString() {
    //can remove later if necessary
    return 'ExerciseDescription(id: $_id, name: $_name, description: $_description, muscle_group: $_muscleGroup, is_compound: $_isCompound, is_machine: $_isMachine)';
  }
}

class ExerciseSet {
  int? _exerciseID;
  int _position = 0; //workout ID and position form primary key
  double _weight = 0;
  int _reps = 0;
  int _rpe = 10;
  String? _note = '';
  bool _inKG = false;
  bool _complete = false;

  ExerciseSet.fromDatabase(int exerciseID, int position, double weight,
      int reps, int rpe, String note, int inKG) {
    _exerciseID = exerciseID;
    _position = position;
    _weight = weight;
    _reps = reps;
    _rpe = rpe;
    _note = note;
    _inKG = (inKG == 0) ? false : true;
    _complete = true;
  }

  ExerciseSet.fromBlank([this._exerciseID]);

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
