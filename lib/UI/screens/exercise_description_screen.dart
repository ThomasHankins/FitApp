import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/database/database.dart';
import '../components/clock_converter.dart';

/*
Takes a Workout class and will display the information
 */
class ExerciseDescriptionScreen extends StatefulWidget {
  final ExerciseDescription thisExercise;

  const ExerciseDescriptionScreen({Key? key, required this.thisExercise})
      : super(key: key);

  @override
  _ExerciseDescriptionScreenState createState() =>
      _ExerciseDescriptionScreenState();
}

class _ExerciseDescriptionScreenState extends State<ExerciseDescriptionScreen> {
  bool loaded = false;
  late ExerciseDescription thisExercise;
  late List<Map<DateTime, ExerciseSet>> history;

  Future<void> loadExercise() async {
    thisExercise = widget.thisExercise;
    history = await DatabaseManager().getSetsFromDescription(thisExercise);
    loaded = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadExercise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: loaded ? Text(thisExercise.name) : null,
      ),
      body: loaded
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: history.length,
              itemBuilder: (context, i) {
                return ListTile(
                  horizontalTitleGap: 0,
                  title: Text(ClockConverter()
                      .iso8601ToFormatted(history.elementAt(i).keys.first)),
                  subtitle: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: history.elementAt(i).values.first.sets.length,
                    itemBuilder: (context, j) {
                      ExerciseSet thisSet =
                          history.elementAt(i).values.first.sets[j];
                      return (thisSet is HistoricSet)
                          ? Text(thisSet.reps.toString() +
                              ' x ' +
                              thisSet.weight.toStringAsFixed(
                                  thisSet.weight.truncateToDouble() ==
                                          thisSet.weight
                                      ? 0
                                      : 1) +
                              'lbs')
                          : Text(
                              (thisSet as HistoricCardio).distance.toString() +
                                  ' in ' +
                                  ClockConverter()
                                      .secondsToFormatted(thisSet.duration)
                                      .toString());
                    },
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
