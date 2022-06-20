import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

/*
Takes a Workout class and will display the information
 */
class HistoryDetailScreen extends StatefulWidget {
  HistoricWorkout thisWorkout;

  HistoryDetailScreen({Key? key, required this.thisWorkout}) : super(key: key);

  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  bool loaded = false;
  late HistoricWorkout thisWorkout;

  Future<void> loadWorkout() async {
    //TODO investigate why this exists and maybe delete
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
            : null, //TODO add length information and total volume also extend height of app bar - future feature idea to add analytics
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
                      horizontalTitleGap: 0,
                      onTap:
                          () {}, //TODO opens exercise description page (need to create page first)
                      title: Text(thisWorkout.exercises[i].description.name),
                      subtitle: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: thisWorkout.exercises[i].sets.length,
                        itemBuilder: (context, j) {
                          return (thisWorkout.exercises[i].sets[j]
                                  is HistoricSet)
                              ? Text((thisWorkout.exercises[i].sets[j]
                                          as HistoricSet)
                                      .reps
                                      .toString() +
                                  ' x ' +
                                  (thisWorkout.exercises[i].sets[j]
                                          as HistoricSet)
                                      .weight
                                      .toString() +
                                  'lbs')
                              : Text((thisWorkout.exercises[i].sets[j]
                                          as HistoricCardio)
                                      .distance
                                      .toString() +
                                  ' in ' +
                                  ClockConverter()
                                      .secondsToFormatted((thisWorkout
                                              .exercises[i]
                                              .sets[j] as HistoricCardio)
                                          .duration)
                                      .toString());
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
