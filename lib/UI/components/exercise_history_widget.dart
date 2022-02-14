import 'package:fit_app/workout-tracker/exercise.dart';
import 'package:flutter/material.dart';


class ExerciseHistoryWidget extends StatelessWidget {
  ExerciseHistoryWidget({required this.thisExercise});
  final Exercise thisExercise;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(thisExercise.name),
        ],
      ),
      subtitle: ListView.builder(
        shrinkWrap: true,
        itemCount: thisExercise.sets.length,
        itemBuilder: (context, i) {
          return ListTile(
        title: Row(
          children: [
              Text('Reps: ' + thisExercise.sets[i].getReps().toString()),
              Text('Weight: ' + thisExercise.sets[i].getWeight().toString()),
            ],
      ),
    );
    },),
      );
  }
}
