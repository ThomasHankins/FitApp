import 'package:fit_app/UI/screens/set_screen.dart';
import 'package:fit_app/workout-tracker/exercise.dart';
import 'package:flutter/material.dart';

import '../screens/set_screen.dart';

class ExerciseWidget extends StatelessWidget {
  const ExerciseWidget({Key? key, required this.thisExercise})
      : super(key: key);
  final Exercise thisExercise;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: thisExercise.isDone,
      title: Row(
        children: [
          Text(thisExercise.name),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetScreen(
              thisExercise: thisExercise,
            ),
          ),
        );
      },
    );
  }
}
