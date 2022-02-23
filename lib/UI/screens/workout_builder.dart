import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/exercise.dart';
import '../../workout-tracker/workout.dart';
import 'dashboard.dart';
import 'search_screen.dart';

class WorkoutBuilderScreen extends StatefulWidget {
  Future<Workout> thisWorkout;
  int? planID;
  WorkoutBuilderScreen({Key? key, required this.thisWorkout, this.planID})
      : super(key: key);

  @override
  _WorkoutBuilderScreenState createState() => _WorkoutBuilderScreenState();
}

class _WorkoutBuilderScreenState extends State<WorkoutBuilderScreen> {
  late Workout thisWorkout;
  bool loaded = false;

  Future<void> loadWorkout() async {
    thisWorkout = await widget.thisWorkout;
    loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    loadWorkout();
    super.initState();
  }

  late Exercise currentExercise = thisWorkout.exercises.first;
  @override
  Widget build(BuildContext context) {
    return loaded
        ? Scaffold(
            appBar: AppBar(
              title: Text(thisWorkout.name), //TODO allow editing name
              //TODO enable back arrow
              //TODO Add prompt on return to home screen confirming cancel
            ),
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
                          child: ListTile(
                            title: Text(thisWorkout.exercises[i].name),
                          )),
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(30),
                      elevation: 10.0,
                      color: Colors.grey[850],
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
                        child: const Text(
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
              label: const Text("Save Workout"),
              icon: const Icon(Icons.save_outlined),
              onPressed: () {
                //TODO add popup confirming save
                thisWorkout.saveWorkout(widget.planID);
                //end workout
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Dashboard(),
                  ),
                );
              },
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
