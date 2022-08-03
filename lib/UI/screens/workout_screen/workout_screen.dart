import 'dart:async';

import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/UI/components/tuples.dart';
import 'package:fit_app/UI/screens/workout_screen/workout_screen_components/dissmissible_widget.dart';
import 'package:fit_app/UI/screens/workout_screen/workout_screen_components/exercise_widget.dart';
import 'package:flutter/material.dart';

import '../../../workout-tracker/data_structures/structures.dart';
import '../dashboard.dart';
import '../search_screen.dart';

class WorkoutScreen extends StatefulWidget {
  final Future<LiveWorkout> thisWorkout;
  const WorkoutScreen({
    Key? key,
    required this.thisWorkout,
  }) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late LiveWorkout thisWorkout;
  late List<Tuple<ExerciseDescription, Tuple<int, int>>> _exercises;
  bool loaded = false;
  int clock = 0;

  Future<void> loadWorkout() async {
    //this might be redundant since thisWorkout is not longer a future, need to check with synchronization issues before deleting
    thisWorkout = await widget.thisWorkout;
    thisWorkout.start(); // start workout clock
    loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    loadWorkout();
    super.initState();

    _exercises = getMapping();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        return setState(() {
          int time = thisWorkout.workoutTimer.elapsed.inSeconds;
          clock = time;
        });
      }
    });
  }

  List<Tuple<ExerciseDescription, Tuple<int, int>>> getMapping() {
    int counter = 0;
    return thisWorkout.sets
        .fold(<Tuple<ExerciseDescription, Tuple<int, int>>>[],
            (List<Tuple<ExerciseDescription, Tuple<int, int>>> list, item) {
      if (list.isEmpty || list.last.a.name != item.description.name) {
        list.add(Tuple(item.description, Tuple(counter, counter)));
      } else {
        list.last.b.b++;
      }
      counter++;
      return list;
    });
  }

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
                  if (!thisWorkout.hasStarted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ),
                    );
                  } else {
                    showDialog(
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
                  }
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
            body: CustomScrollView(
              slivers: [
                SliverReorderableList(
                  itemCount: _exercises.length,
                  itemBuilder: (context, i) {
                    return DismissibleWidget(
                        item: _exercises[i],
                        key: Key('$i'),
                        onDismissed: (dismissDirection) {
                          setState(() {
                            for (int index = _exercises[i].b.a;
                                index < _exercises[i].b.b;
                                index++) {
                              thisWorkout.deleteSet(index);
                            }
                          });
                        },
                        child: ExerciseWidget(
                          thisWorkout: thisWorkout,
                          exerciseSets: _exercises[i].b,
                          ed: _exercises[i].a,
                        ));
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      int modifier = 0;
                      if (oldIndex < newIndex) {
                        modifier =
                            _exercises[newIndex].b.b - _exercises[newIndex].b.a;
                      }

                      for (int index = 0;
                          index <=
                              _exercises[oldIndex].b.b -
                                  _exercises[oldIndex].b.a;
                          index++) {
                        if (oldIndex < newIndex) {
                          thisWorkout.reorderSet(_exercises[oldIndex].b.a,
                              _exercises[newIndex].b.a + modifier);
                        } else {
                          thisWorkout.reorderSet(
                              _exercises[oldIndex].b.a + index,
                              _exercises[newIndex].b.a + index);
                        }
                      }

                      _exercises = getMapping();
                    });
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 100),
                    child: Material(
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
                        minWidth: 10.0,
                        child: const Text(
                          "Add Set",
                        ),
                        height: 42.0,
                      ),
                    ),
                  ),
                ),
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
                      thisWorkout.workoutTimer.stop();
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
                                thisWorkout.workoutTimer.start();
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
