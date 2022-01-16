import 'package:fit_app/UI/screens/exercise_screen.dart';
import 'package:fit_app/workout-tracker/exercise.dart';
import 'package:flutter/material.dart';

import '../screens/exercise_screen.dart';

class ExerciseWidget extends StatelessWidget {
  ExerciseWidget({required this.thisExercise});
  final Exercise thisExercise;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(thisExercise.name),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseScreen(
              thisExercise: thisExercise,
            ),
          ),
        );
      },
    );
  }
}
