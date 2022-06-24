import 'dart:async';

import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/data_structures/structures.dart';
import '../components/exercise_widget.dart';
import 'dashboard.dart';
import 'search_screen.dart';

class WorkoutScreen extends StatefulWidget {
  LiveWorkout thisWorkout;
  WorkoutScreen({
    Key? key,
    required this.thisWorkout,
  }) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late LiveWorkout thisWorkout;
  bool loaded = false;
  int clock = 0;

  Future<void> loadWorkout() async {
    //this might be redundant since thisWorkout is not longer a future, need to check with synchronization issues before deleting
    thisWorkout = widget.thisWorkout;
    thisWorkout.timer.start(); // start workout clock
    loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    loadWorkout();
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        return setState(() {
          int time = thisWorkout.timer.elapsed.inSeconds;
          clock = time;
        });
      }
    });
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
                          title: const Text(
                              'Are you sure you want to cancel workout?'),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: <Widget>[
                            MaterialButton(
                              child: const Text('Yes'),
                              onPressed: () async {
                                Navigator.pop(context, 'Yes');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Dashboard(),
                                  ),
                                );
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
              title: Row(children: [
                SizedBox(
                  width: 260,
                  child: TextFormField(
                    initialValue: thisWorkout.name,
                    maxLength: 28,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        counterText: "", border: InputBorder.none),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.headline5,
                    onChanged: (changes) {
                      thisWorkout.name = changes;
                    },
                  ),
                ),
                Text(
                  ClockConverter().secondsToFormatted(clock),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ]),
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
                          child: ExerciseWidget(
                            index: i,
                            thisWorkout: thisWorkout,
                          )),
                    );
                  },
                  //TODO block reorder on completed sets
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      thisWorkout.reorderExercises(oldIndex, newIndex);
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
              label: const Text("Finish Workout"),
              icon: const Icon(Icons.logout),
              onPressed: () async {
                return showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      thisWorkout.timer.stop();
                      return AlertDialog(
                          title: const Center(
                            child: Text(
                                'Are you sure you want to end the workout?'),
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: <Widget>[
                            MaterialButton(
                              child: const Text('Yes'),
                              onPressed: () async {
                                await thisWorkout.endWorkout();
                                Navigator.pop(context, 'Yes');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Dashboard(),
                                  ),
                                );
                              },
                            ),
                            MaterialButton(
                              child: const Text('Cancel'),
                              onPressed: () async {
                                Navigator.pop(context, 'Cancel');
                                thisWorkout.timer.start();
                              },
                            )
                          ]);
                    });
              },
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
