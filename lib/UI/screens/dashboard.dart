import 'package:fit_app/UI/screens/saved_workouts.dart';
import 'package:fit_app/workout-tracker/data_structures/workout.dart';
import 'package:fit_app/workout-tracker/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'dashboard_components/dashboard_ui.dart';
import 'dashboard_components/workout_history_ui.dart';
import 'workout_builder.dart';
import 'workout_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<HistoricWorkout> history = [];
  //List<SavedWorkouts> savedWorkouts = [];
  bool showHistory = false;

  @override
  void initState() {
    loadFiles();
    super.initState();
  }

  bool loaded = false;

  Future<void> loadFiles() async {
    history = await DatabaseManager().getHistoricWorkouts();
    //savedWorkouts = await DatabaseManager().getSavedWorkouts();
    loaded = true;
    setState(() {});
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded
          ? (showHistory //TODO highlight dashboard/history whatever is being shown
              ? HistoryWidget(
                  setState: updateState,
                  history:
                      history, //TODO add a refresh which refreshes this list
                )
              : DashboardWidget(
                  setState: updateState,
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
                  thisWorkout: LiveWorkout(),
                ), //TODO will change to plan workout if available
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
                      builder: (context) => const SavedWorkouts(),
                    ),
                  );
                }),
          ]),
    );
  }
}
