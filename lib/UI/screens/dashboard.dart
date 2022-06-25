import 'package:fit_app/UI/screens/saved_workouts.dart';
import 'package:fit_app/workout-tracker/data_structures/workout.dart';
import 'package:fit_app/workout-tracker/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'main_screen_components/dashboard_ui.dart';
import 'main_screen_components/workout_history_ui.dart';
import 'workout_builder.dart';
import 'workout_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<HistoricWorkout> history = [];
  List<FutureWorkout> savedWorkouts = [];
  bool showHistory = false;
  late List<Map<String, dynamic>> stuff;
  @override
  void initState() {
    loadFiles();
    super.initState();
  }

  bool loaded = false;

  Future<void> loadFiles() async {
    history = await DatabaseManager().getHistoricWorkouts();
    stuff = await DatabaseManager().testFunc();
    savedWorkouts = await DatabaseManager().getSavedWorkouts();
    loaded = true;
    setState(() {});
  }

  // void updateState() => setState(() => Null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded
          ? (showHistory
              ? HistoryWidget(
                  history: history,
                )
              : DashboardWidget(
                  history: history,
                ))
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: Material(
        child: BottomAppBar(
          color: Theme.of(context).bottomAppBarColor,
          shape: const CircularNotchedRectangle(),
          child: Row(
            children: <Widget>[
              MaterialButton(
                color: showHistory
                    ? Theme.of(context).bottomAppBarColor
                    : Theme.of(context).focusColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
                child: const Text('Dashboard'),
                onPressed: () {
                  setState(() {
                    showHistory = false;
                  });
                },
              ),
              const Spacer(),
              MaterialButton(
                color: showHistory
                    ? Theme.of(context).focusColor
                    : Theme.of(context).bottomAppBarColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
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
                  thisWorkout: LiveWorkout(),
                ),
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
                        thisWorkout: LiveWorkout(), //makes a new blank workout
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
                        thisWorkout: FutureWorkout(),
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
                        builder: (context) => SavedWorkoutsScreen(
                              plans: savedWorkouts,
                            )),
                  );
                }),
          ]),
    );
  }
}
