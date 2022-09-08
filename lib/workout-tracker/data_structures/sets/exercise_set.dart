import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:fit_app/workout-tracker/database/database.dart';

// import 'package:objectbox/objectbox.dart';

class ExerciseSet {
  SetDetails details;
  final ExerciseDescription _description;
  late final int _workoutId;
  late final int _time;
  late final int _position;
  late final int _id;

  bool _complete = false;
  bool get isComplete => _complete;

  int get id => _id;

  void complete(int workoutId, int timestamp, int position) async {
    _workoutId = workoutId;
    _complete = true;
    _time = timestamp;

    //insert into db on completion
    _id = await DatabaseManager().insertHistoricSet(this);
    details.saveToDatabase(_id);
  }

  ExerciseSet({
    required this.details,
    required ExerciseDescription description,
  }) : _description = description;

  static Future<ExerciseSet> late(
      {required Future<SetDetails> futureDetails,
      required ExerciseDescription description}) async {
    SetDetails details = await futureDetails;
    return ExerciseSet(details: details, description: description);

  }

  ExerciseSet.fromDatabase({
    required this.details,
    required ExerciseDescription description,
    required int workoutId,
    required int time,
    required int position,
    required int id,
  })  : _description = description,
        _workoutId = workoutId,
        _time = time,
        _position = position,
        _id = id;

  get description => _description;

  Map<String, dynamic> toMap() {
    //TODO verify correctness
    return {
      'workout_id': _workoutId,
      'position': _position,
      'time_marker': _time,
    };
  }

  @override
  String toString(){
    return "\n${_description.name}: \n $details";
  }
}
