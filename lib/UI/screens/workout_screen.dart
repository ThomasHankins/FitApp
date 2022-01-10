import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/exercise.dart';
import '../components/set_widget.dart';

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

  List<ExerciseSet> exerciseSets = [];
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
                itemCount: exerciseSets.length,
                itemBuilder: (context, i) {
                  return DismissibleWidget(
                    item: exerciseSets[i],
                    onDismissed: (DismissDirection) {
                      setState(() {
                        exerciseSets.removeAt(i);
                      });
                    },
                    child: SetWidget(activeSet: exerciseSets[i]),
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
                          exerciseSets.add(
                            ExerciseSet(10, 10, false, ""),
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
