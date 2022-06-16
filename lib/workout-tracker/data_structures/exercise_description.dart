import '../file_manager.dart';

class ExerciseDescription {
  final int _id;
  String _name;
  String? _description;
  String? _exerciseType; //eventually will reference "cardio or strength"

  int get id => _id;
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
  ]) : _id = DatabaseManager().nextExerciseDescriptionID {
    DatabaseManager().insertExerciseDescription(this); //insert ED
  }

  //constructor from db imports
  ExerciseDescription.fromDatabase({
    required int id,
    required String name,
    required String? description,
    required String? exerciseType,
  })  : _id = id,
        _name = name,
        _description = description,
        _exerciseType = exerciseType;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'description': _description,
      'exercise_type': _exerciseType,
    };
  }

  @override
  String toString() =>
      'ExerciseDescription(id: $_id, name: $_name, description: $_description, exercise_type: $_exerciseType)';
}
