import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/data_structures/exercise.dart';
import '../../workout-tracker/data_structures/workout.dart';
import 'dashboard.dart';
import 'search_screen.dart';

class WorkoutBuilderScreen extends StatefulWidget {
  Workout thisWorkout;
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
    //might also be able to remove this function -- again need to check for sync issues
    thisWorkout = widget.thisWorkout;
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
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  return showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(
                            child: Text(
                                'Are you sure you want to discard changes?'),
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: <Widget>[
                            MaterialButton(
                              child: const Text('Yes'),
                              onPressed: () async {
                                Navigator.pop(context, 'Yes');
                                Navigator.pop(context);
                              },
                            ),
                            MaterialButton(
                              child: const Text('Cancel'),
                              onPressed: () async {
                                Navigator.pop(context, 'Cancel');
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
              title: TextFormField(
                initialValue: thisWorkout.name,
                decoration: const InputDecoration(
                    counterText: "", border: InputBorder.none),
                keyboardType: TextInputType.text,
                onChanged: (changes) {
                  thisWorkout.name = changes;
                },
              ),
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
                            title:
                                Text(thisWorkout.exercises[i].description.name),
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
                      borderRadius: BorderRadius.circular(15),
                      elevation: 10.0,
                      color: Colors.grey[850],
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseSearch(
                                currentWorkout: thisWorkout,
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
                thisWorkout.endWorkout();
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
