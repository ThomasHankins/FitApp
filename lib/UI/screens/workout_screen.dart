import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/exercise.dart';
import '../../workout-tracker/workout.dart';
import '../components/exercise_widget.dart';

class WorkoutScreen extends StatefulWidget {
  static String id = 'workout_screen';

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  void initState() {
    super.initState();
  }

  Workout currentWorkout = Workout.fromEmpty();
  late Exercise currentExercise = currentWorkout.exercises.first;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueGrey[900],
          body: Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: currentWorkout.exercises.length,
                itemBuilder: (context, i) {
                  return DismissibleWidget(
                    item: currentWorkout.exercises[i],
                    onDismissed: (DismissDirection) {
                      setState(() {
                        currentWorkout.exercises.removeAt(i);
                      });
                    },
                    child: ExerciseWidget(
                        thisExercise: currentWorkout.exercises[i]),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          //will obviously need to update this to be able to select exercise
                          currentWorkout.exercises.add(
                            Exercise("Test Exercise", []),
                          );
                        });
                      },
                      minWidth: 50.0,
                      child: Text(
                        "Add Exercise",
                      ),
                      height: 42.0,
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: null,
                      minWidth: 50.0,
                      child: Text(
                        "Log Workout",
                      ),
                      height: 42.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
