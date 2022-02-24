import 'dart:convert' show json;

import 'package:fit_app/UI/screens/workout_builder.dart';
import 'package:fit_app/workout-tracker/file_manager.dart';
import 'package:fit_app/workout-tracker/workout.dart';
import 'package:flutter/material.dart';

import 'workout_screen.dart';

class SavedWorkouts extends StatefulWidget {
  const SavedWorkouts({Key? key}) : super(key: key);
  @override
  _SavedWorkoutsState createState() => _SavedWorkoutsState();
}

class _SavedWorkoutsState extends State<SavedWorkouts> {
  List<dynamic> plans = [];

  @override
  void initState() {
    loadFiles();
    super.initState();
  }

  bool loaded = false;
  Future<void> loadFiles() async {
    plans = json.decode(await FileManager().readFile('plans'));
    loaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded
          ? Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: plans.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Row(
                        children: [
                          Text(plans[i]["name"].toString()),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return WorkoutBuilderScreen(
                                    thisWorkout:
                                        Workout.fromSaved(plans[i]["plan id"]),
                                    planID: plans[i]["plan id"],
                                  );
                                },
                              ));
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.lightGreenAccent,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              plans.removeAt(i);
                              FileManager()
                                  .writeFile('plans', json.encode(plans));
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            //TODO fix infinite loading
                            return WorkoutScreen(
                              thisWorkout:
                                  Workout.fromSaved(plans[i]["plan id"]),
                            );
                          },
                        ));
                      },
                    );
                  },
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
