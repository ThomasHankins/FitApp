import '../../../structures.dart';

SetDetails blankSet(ExerciseDescription description) {
  if (description.exerciseType == DetailType.strength) {
    return StrengthDetails(
        note: "", restTime: 0, weight: 0, reps: 0, rpe: null);
  } else {
    return CardioDetails(note: "", restTime: 0, duration: 0, distance: 0);
  }
}
