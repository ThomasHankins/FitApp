import 'package:fit_app/UI/screens/workout_builder.dart';
import 'package:fit_app/UI/screens/workout_screen.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

class SavedWorkouts extends StatefulWidget {
  //TODO change class name to eliminate confusion
  List<FutureWorkout> plans;

  SavedWorkouts({Key? key, required this.plans}) : super(key: key);
  @override
  _SavedWorkoutsState createState() => _SavedWorkoutsState();
}

class _SavedWorkoutsState extends State<SavedWorkouts> {
  bool loaded = false;
  late List<FutureWorkout> plans;

  @override
  void initState() {
    plans = widget.plans;
    loadFiles();
    super.initState();
  }

  Future<void> loadFiles() async {
    //TODO review if needed
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
                  itemCount: 0, //TODO replace with plans.length
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Row(
                        children: [
                          Text(""), //TODO replace with plans[i].name
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return WorkoutBuilderScreen(
                                    thisWorkout:
                                        FutureWorkout(), //replace with saved

                                    //TODO open workout builder screen with saved plan
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
                              //TODO call delete plan in file manager - for this plan
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
                            return WorkoutScreen(
                              thisWorkout: LiveWorkout(),
                              //TODO change to saved workout plan
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
