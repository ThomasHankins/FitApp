import 'package:flutter/material.dart';

import '../../workout-tracker/workout.dart';

/*
Takes a Workout class and will display the information
 */
class HistoryDetailScreen extends StatefulWidget {
  Future<Workout> thisWorkout;

  HistoryDetailScreen({required this.thisWorkout});

  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

//TODO improve appearance
class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  bool loaded = false;
  late Workout thisWorkout;

  Future<void> loadWorkout() async {
    thisWorkout = await widget.thisWorkout;
    loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadWorkout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: loaded ? Text(thisWorkout.name) : null,
      ),
      body: loaded
          ? Column(
              children: [
                //TODO add some other information about the workout at the top
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: thisWorkout.exercises.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      horizontalTitleGap: 0,
                      title: Text(thisWorkout.exercises[i].name),
                      subtitle: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: thisWorkout.exercises[i].sets.length,
                        itemBuilder: (context, j) {
                          return Text(
                              thisWorkout.exercises[i].sets[j].reps.toString() +
                                  ' x ' +
                                  thisWorkout.exercises[i].sets[j].weight
                                      .toString() +
                                  'lbs');
                        },
                      ),
                    );
                  },
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
