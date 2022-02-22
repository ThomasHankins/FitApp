import 'dart:convert' show json;

import 'package:fit_app/workout-tracker/FileManager.dart';
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
  bool showHistory = false;
  @override
  void initState() {
    loadHistory();
    super.initState();
  }

  void loadHistory() async {
    history = json.decode(await HistoryManager().readHistory());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showHistory
          ? Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: history.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                        //TODO improve widget appearance
                        title: Text(history[i]["name"]),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoryDetailScreen(
                                  thisWorkout:
                                      Workout.fromHistoricJSON(history[i]),
                                ),
                              )
                              //move to workout detail
                              );
                        });
                  },
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[], //TODO Add dashboard content here
              ),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WorkoutScreen(), //can change to workout history screen later
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WorkoutScreen(), //can change to workout history screen later
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
                      builder: (context) =>
                          WorkoutBuilderScreen(), //can change to workout history screen later
                    ),
                  );
                }),
            SpeedDialChild(
                child: const Icon(Icons.save),
                label: 'Saved Workouts',
                onTap: () {
                  //TODO ADD LINK TO SAVED WORKOUT SCREEN
                }),
          ]),
    );
  }
}
