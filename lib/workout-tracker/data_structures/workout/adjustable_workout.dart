//includes both live and future workouts

import 'package:fit_app/workout-tracker/data_structures/sets/exercise_description.dart';
import 'package:fit_app/workout-tracker/data_structures/workout/workout.dart';

abstract class AdjustableWorkout extends Workout {
  void addSet(ExerciseDescription desc, [int? position]);
  void deleteSet(int position);
  void reorderSet(int oldPosition, int newPosition);
}
