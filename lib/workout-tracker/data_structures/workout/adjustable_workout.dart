//includes both live and future workouts

import 'package:fit_app/workout-tracker/data_structures/sets/exercise_description.dart';
import 'package:fit_app/workout-tracker/data_structures/workout/workout.dart';

abstract class AdjustableWorkout extends Workout {
  void addExercise(ExerciseDescription desc, [int? position]);
  void deleteExercise(int position);
  void reorderExercises(int oldPosition, int newPosition);
}
