import 'dart:convert' show json;

import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/UI/screens/saved_workouts.dart';
import 'package:fit_app/workout-tracker/file_manager.dart';
import 'package:fit_app/workout-tracker/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'history_detail.dart';
import 'workout_builder.dart';
import 'workout_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> history = [];
  List<dynamic> exercises = [];
  bool showHistory = false;
  @override
  void initState() {
    loadFiles();
    super.initState();
  }

  bool loaded = false;
  Future<void> loadFiles() async {
    history = json.decode(await FileManager().readFile('history'));
    exercises = json.decode(await FileManager().readFile('exercises'));
    loaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded
          ? (showHistory //TODO highlight dashboard/history whatever is being shown - will implement with new data structure
              ? SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: history.length,
                        itemBuilder: (context, i) {
                          i = history.length - i - 1; //flip indicies
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(history[i]["name"].toString()),
                                IconButton(
                                  //TODO format so that button is hidden unless long press
                                  onPressed: () {
                                    int tempID = history[i]["workout id"];
                                    history.removeAt(i);
                                    for (Map<String, dynamic> exercise
                                        in exercises) {
                                      exercise["previous efforts"].removeWhere(
                                          (element) =>
                                              element["workout id"] == tempID);
                                    }
                                    FileManager().writeFile(
                                        'history', json.encode(history));
                                    FileManager().writeFile(
                                        'exercises', json.encode(exercises));
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    history[i]["date"],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.timelapse_outlined,
                                  size: 12,
                                  color: Colors.white38,
                                ),
                                Text(
                                  ClockConverter()
                                      .convert(history[i]["length"]),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return HistoryDetailScreen(
                                    thisWorkout: Workout.fromHistoric(
                                        history[i]["workout id"],
                                        history[i]["name"].toString(),
                                        history[i]["exercises"]),
                                  );
                                },
                              ));
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[], //TODO Add dashboard content here
                  ),
                ))
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: Material(
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            children: <Widget>[
              MaterialButton(
                child: const Text('Dashboard'),
                onPressed: () {
                  setState(() {
                    showHistory = false;
                  });
                },
              ),
              const Spacer(),
              MaterialButton(
                child: const Text('History'),
                onPressed: () {
                  setState(() {
                    showHistory = true;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
          onPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutScreen(
                  thisWorkout: Workout.fromEmpty(),
                ), //TODO will change to program workout if available
              ),
            );
          },
          overlayColor: Colors.black,
          overlayOpacity: .3,
          icon: const IconData(0xe28d, fontFamily: 'MaterialIcons'),
          children: [
            SpeedDialChild(
                child: const Icon(Icons.new_label),
                label: 'Blank Workout',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutScreen(
                        thisWorkout: Workout.fromEmpty(),
                      ),
                    ),
                  );
                }),
            SpeedDialChild(
                child: const Icon(Icons.build),
                label: 'Build Workout',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutBuilderScreen(
                        thisWorkout: Workout.fromEmpty(),
                      ),
                    ),
                  );
                }),
            SpeedDialChild(
                child: const Icon(Icons.save),
                label: 'Saved Workouts',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedWorkouts(),
                    ),
                  );
                }),
          ]),
    );
  }
}
