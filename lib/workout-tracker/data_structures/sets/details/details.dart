import 'package:fit_app/workout-tracker/data_structures/sets/details/set_builders/blank_set_builder.dart';
import 'package:fit_app/workout-tracker/data_structures/sets/details/set_builders/copy_set_builder.dart';
import 'package:fit_app/workout-tracker/data_structures/sets/details/set_builders/last_workout_set_builder.dart';
import 'package:fit_app/workout-tracker/data_structures/sets/details/set_builders/logic_set_builder.dart';
import 'package:fit_app/workout-tracker/data_structures/sets/details/set_builders/plan_set_builder.dart';

import '../../structures.dart';

abstract class SetDetails {
  Duration restedTime;
  String _note;

  String get note => _note;
  set note(String note) =>
      note.length < 30 ? _note = note : _note = note.substring(0, 30);

  //all of the information will be passed through the set builder class
  SetDetails({required int restTime, required String note})
      : _note = note,
        restedTime = Duration(seconds: restTime);

  factory SetDetails.blank(ExerciseDescription description) =>
      blankSet(description);
  factory SetDetails.copy(SetDetails details) => copySet(details);
  factory SetDetails.last(ExerciseDescription description, int position) =>
      lastSet(description, position);
  factory SetDetails.logic(ExerciseDescription description) =>
      logicSet(description);
  factory SetDetails.plan(ExerciseDescription description) =>
      planSet(description);

  Map<String, dynamic> toMap();
  void saveToDatabase(int setId);
}
