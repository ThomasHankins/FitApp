import 'package:fit_app/workout-tracker/exercise.dart';
import 'package:flutter/material.dart';

class SetWidget extends StatelessWidget {
  SetWidget({required this.activeSet});
  final ExerciseSet activeSet;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text("Weight " + activeSet.getWeight().toString() + " lbs"),
          Text("Reps " + activeSet.getReps().toString()),
        ],
      ),
    );
  }
}
