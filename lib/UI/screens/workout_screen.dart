import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/exercise.dart';
import '../../workout-tracker/workout.dart';
import '../components/exercise_widget.dart';
import 'dashboard.dart';
import 'search_screen.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  void initState() {
    super.initState();
  }

  Workout thisWorkout = Workout.fromEmpty();
  late Exercise currentExercise = thisWorkout.exercises.first;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ReorderableListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: thisWorkout.exercises.length,
              itemBuilder: (context, i) {
                return DismissibleWidget(
                  item: thisWorkout.exercises[i],
                  key: Key('$i'),
                  onDismissed: (dismissDirection) {
                    setState(() {
                      thisWorkout.exercises.removeAt(i);
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: .2),
                      child: ExerciseWidget(
                          thisExercise: thisWorkout.exercises[i])),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Exercise item =
                      thisWorkout.exercises.removeAt(oldIndex);
                  thisWorkout.exercises.insert(newIndex, item);
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseSearch(
                            currentExercises: thisWorkout.exercises,
                            notifyParent: () {
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                    minWidth: 50.0,
                    child: Text(
                      "Add Exercise",
                    ),
                    height: 42.0,
                  ),
                ),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Finish Workout"),
          icon: const Icon(Icons.logout),
          onPressed: () {
            //TODO add popup confirming end of workout
            thisWorkout.endWorkout();
            //end workout
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ),
            );
          },
        ),
      ),
    );
  }
}
