import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

//TODO this needs a complete overhaul
class ExerciseWidget extends StatelessWidget {
  final LiveWorkout thisWorkout;
  final int index;
  const ExerciseWidget(
      {Key? key, required this.thisWorkout, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(thisWorkout.sets[index].description.name),
        ],
      ),
      onTap: () {
        throw UnimplementedError();
      },
    );
  }
}
