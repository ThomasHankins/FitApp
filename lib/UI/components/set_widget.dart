import 'package:fit_app/workout-tracker/exercise.dart';
import 'package:flutter/material.dart';

class SetWidget extends StatelessWidget {
  SetWidget({required this.thisSet});
  final ExerciseSet thisSet;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text("Weight " + thisSet.getWeight().toString() + " lbs"),
          Text("Reps " + thisSet.getReps().toString()),
        ],
      ),
    );
  }
}
