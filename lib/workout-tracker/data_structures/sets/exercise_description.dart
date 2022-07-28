import '../../database/database.dart';

class ExerciseDescription {
  String _name;
  String? _description;
  String? _exerciseType; //eventually will reference "cardio or strength"

  String get name => _name;
  String get description => _description ?? "";
  String get exerciseType => _exerciseType ?? "";

  set name(String nm) {
    _name = nm;
    DatabaseManager().updateExerciseDescription(this);
  }

  set description(String ds) {
    _description = ds;
    DatabaseManager().updateExerciseDescription(this);
  }

  set exerciseType(String et) {
    _exerciseType = et;
    DatabaseManager().updateExerciseDescription(this);
  }

  //constructor for new descriptions
  ExerciseDescription(
    this._name, [
    this._description,
    this._exerciseType,
  ]) {
    DatabaseManager().insertExerciseDescription(this); //insert ED
  }

  ExerciseDescription.test(
    //to make test ED's without inserting into the DB
    this._name, [
    this._description,
    this._exerciseType,
  ]);

  //constructor from db imports
  ExerciseDescription.fromDatabase({
    required String name,
    required String? description,
    required String? exerciseType,
  })  : _name = name,
        _description = description,
        _exerciseType = exerciseType;

  Map<String, dynamic> toMap() {
    //TODO update to reflect DBv2
    return {
      'name': _name,
      'description': _description,
      'exercise_type': _exerciseType,
    };
  }
}
