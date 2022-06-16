import 'package:fit_app/UI/screens/set_screen.dart';
import 'package:fit_app/workout-tracker/data_structures/exercise.dart';
import 'package:flutter/material.dart';

import '../screens/set_screen.dart';

class ExerciseWidget extends StatelessWidget {
  const ExerciseWidget({Key? key, required this.thisExercise})
      : super(key: key);
  final Exercise thisExercise;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: thisExercise.isAllDone,
      title: Row(
        children: [
          Text(thisExercise.description.name),
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
