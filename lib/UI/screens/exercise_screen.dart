import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/exercise.dart';
import '../components/set_widget.dart';

class ExerciseScreen extends StatefulWidget {
  final Exercise thisExercise;

  ExerciseScreen({required this.thisExercise});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
  }

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
                itemCount: widget.thisExercise.sets.length,
                itemBuilder: (context, i) {
                  return DismissibleWidget(
                    item: widget.thisExercise.sets[i],
                    onDismissed: (DismissDirection) {
                      setState(() {
                        widget.thisExercise.sets.removeAt(i);
                      });
                    },
                    child: SetWidget(thisSet: widget.thisExercise.sets[i]),
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
                          widget.thisExercise.sets.add(
                            ExerciseSet(10, 10, false, ""),
                          );
                        });
                      },
                      minWidth: 50.0,
                      child: Text(
                        "Add Set",
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
                        "Log Exercise",
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
