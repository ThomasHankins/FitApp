import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

import '../exercise_description_screen/exercise_description_screen.dart';

/*
Takes a Workout class and will display the information
 */
class HistoryDetailScreen extends StatefulWidget {
  final HistoricWorkout thisWorkout;

  const HistoryDetailScreen({Key? key, required this.thisWorkout})
      : super(key: key);

  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  bool loaded = false;
  late HistoricWorkout thisWorkout;

  @override
  void initState() {
    thisWorkout = widget.thisWorkout;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(thisWorkout.name),
        ]),
      ),
      body: Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: thisWorkout.sets.length,
            itemBuilder: (context, i) {
              return ListTile(
                horizontalTitleGap: 0,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ExerciseDescriptionScreen(
                        thisExercise: thisWorkout.sets[i].description,
                      );
                    },
                  ));
                },
                title: Text(thisWorkout.sets[i].description.name),
                subtitle: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: thisWorkout.sets[i].sets.length,
                  itemBuilder: (context, j) {
                    return (thisWorkout.sets[i].sets[j] is HistoricSet)
                        ? Text((thisWorkout.exercises[i].sets[j] as HistoricSet).reps.toString() +
                            ' x ' +
                            (thisWorkout.exercises[i].sets[j] as HistoricSet)
                                .weight
                                .toStringAsFixed(
                                    (thisWorkout.exercises[i].sets[j] as HistoricSet)
                                                .weight
                                                .truncateToDouble() ==
                                            (thisWorkout.exercises[i].sets[j] as HistoricSet)
                                                .weight
                                        ? 0
                                        : 1) +
                            'lbs')
                        : Text((thisWorkout.exercises[i].sets[j] as HistoricCardio)
                                .distance
                                .toString() +
                            ' in ' +
                            ClockConverter()
                                .secondsToFormatted((thisWorkout.exercises[i].sets[j] as HistoricCardio).duration)
                                .toString());
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
