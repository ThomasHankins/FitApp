import 'package:fit_app/workout-tracker/file_manager.dart';

class Exercise {
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
      required ExerciseDescription description,
      required this.sets})
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

class ExerciseDescription {
  final int _id;
  final String? _name;
  final String? _description;
  final String? _muscleGroup;
  bool _isCompound = false;
  bool _isMachine = false;

  ExerciseDescription(int compound, int machine, this._id,
      [this._name, this._description, this._muscleGroup]) {
    _isCompound = (compound == 1);
    _isMachine = (machine == 1);
  }

  ExerciseDescription.fromDatabase(
      {required int id,
      required String name,
      required String description,
      required String muscleGroup,
      required int isCompound,
      required int isMachine})
      : _id = id,
        _name = name,
        _description = description,
        _muscleGroup = muscleGroup,
        _isCompound = (isCompound == 1),
        _isMachine = (isMachine == 1);

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

  int get getID {
    if (_id != null) {
      return _id!.toInt();
    } else {
      return -1;
    }
  }

  String get name {
    if (_name != null) {
      return _name.toString();
    } else {
      return "";
    }
  }
}

class ExerciseSet {
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
