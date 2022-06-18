import 'package:fit_app/UI/screens/set_screen.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

import '../screens/set_screen.dart';

class ExerciseWidget extends StatelessWidget {
  final LiveWorkout thisWorkout;
  final int index;
  const ExerciseWidget(
      {Key? key, required this.thisWorkout, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: thisWorkout.exercises[index].isPartiallyFinished,
      title: Row(
        children: [
          Text(thisWorkout.exercises[index].description.name),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetScreen(
              index: index,
              thisWorkout: thisWorkout,
            ),
          ),
        );
      },
    );
  }
}
