import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/exercise.dart';
import '../../workout-tracker/workout.dart';
import '../components/exercise_widget.dart';

import 'search_screen.dart';
import 'welcome_screen.dart';

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

  Workout thisWorkout = Workout.fromEmpty();
  late Exercise currentExercise = thisWorkout.exercises.first;
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
                itemCount: thisWorkout.exercises.length,
                itemBuilder: (context, i) {
                  return DismissibleWidget(
                    item: thisWorkout.exercises[i],
                    onDismissed: (DismissDirection) {
                      setState(() {
                        thisWorkout.exercises.removeAt(i);
                      });
                    },
                    child: ExerciseWidget(
                        thisExercise: thisWorkout.exercises[i]),
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
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: (){
                        thisWorkout.endWorkout();
                        //end workout
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomeScreen(), //can change to workout history screen later
                          ),
                        );
                      },
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
