import '../../database/database.dart';
import 'details/detail_types.dart';

class ExerciseDescription {
  String _name;
  String? _description;
  DetailType _exerciseType;
  ExerciseDescription? _parentExercise;
  String _descriptor = '';

  String get name => _name;
  String get description => _description ?? "";
  DetailType get exerciseType => _exerciseType;

  set name(String nm) {
    _name = nm;
    DatabaseManager().updateExerciseDescription(this);
  }

  set description(String ds) {
    _description = ds;
    DatabaseManager().updateExerciseDescription(this);
  }

  set exerciseType(DetailType et) {
    _exerciseType = et;
    DatabaseManager().updateExerciseDescription(this);
  }

  //constructor for new descriptions
  ExerciseDescription(
    this._name,
    DetailType exerciseType, [
    this._description,
  ]) : _exerciseType = exerciseType {
    DatabaseManager().insertExerciseDescription(
        this); //TODO: review - seems like a bad idea to insert into db without any kind of user response (eg on fail)
  }

  ExerciseDescription.test(
    //to make test ED's without inserting into the DB
    this._name,
    this._exerciseType, [
    this._description,
  ]);

  //constructor from db imports
  ExerciseDescription.fromDatabase({
    required String name,
    required String? description,
    required DetailType exerciseType,
    required ExerciseDescription? parentExercise,
    required String? descriptor,
  })  : _name = name,
        _description = description,
        _exerciseType = exerciseType,
        _parentExercise = parentExercise,
        _descriptor = descriptor ?? '';

  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'description': _description,
      'exercise_type': _exerciseType,
      'parent_exercise': _parentExercise?.name,
      'descriptor': _descriptor,
    };
  }
}
