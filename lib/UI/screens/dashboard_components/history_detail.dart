import 'package:flutter/material.dart';

import '../../../workout-tracker/workout.dart';

/*
Takes a Workout class and will display the information
 */
class HistoryDetailScreen extends StatefulWidget {
  Workout thisWorkout;

  HistoryDetailScreen({Key? key, required this.thisWorkout}) : super(key: key);

  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  bool loaded = false;
  late Workout thisWorkout;

  Future<void> loadWorkout() async {
    thisWorkout = widget.thisWorkout;
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
        title: loaded
            ? Row(children: [
                Text(thisWorkout.name),
              ])
            : null, //TODO add length information and total volume also extend height of app bar
      ),
      body: loaded
          ? Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: thisWorkout.exercises.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      //TODO add ontap that opens exercise description
                      horizontalTitleGap: 0,
                      title: Text(thisWorkout.exercises[i].description.name),
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
