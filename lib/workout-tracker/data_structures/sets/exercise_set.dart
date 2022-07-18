import 'package:fit_app/workout-tracker/data_structures/structures.dart';

import 'details/details.dart';
// import 'package:objectbox/objectbox.dart';

class ExerciseSet {
  SetDetails _details;
  ExerciseDescription _description;

  bool _complete = false;
  bool get isComplete => _complete;

  void complete() {
    _complete = true;
  }

  ExerciseSet(
      {required SetDetails details, required ExerciseDescription description})
      : _details = details,
        _description = description;

  get description => _description;
  get details => _details;
}
