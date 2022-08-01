import 'package:fit_app/UI/screens/exercise_description_screen/exercise_description_components/cardio_description_history_widget.dart';
import 'package:fit_app/UI/screens/exercise_description_screen/exercise_description_components/strength__description_history_widget.dart';
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
  late final HistoricWorkout thisWorkout;
  late List<ExerciseSet> sets;

  @override
  void initState() {
    thisWorkout = widget.thisWorkout;
    sets = thisWorkout.sets;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //group by exercises - if there is an intermediate one they will be separated into two different instances of that exercise
    List<ExerciseDescription> exercises = sets.fold(<ExerciseDescription>[],
        (List<ExerciseDescription> list, item) {
      if (list.isEmpty || list.last.name != item.description.name) {
        //only doing name since I'm not 100% confident the objects will match
        list.add(item.description);
      }
      return list;
    });

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
            itemCount: exercises.length,
            itemBuilder: (context, i) {
              List<ExerciseSet> thisExerciseList = [];
              while (sets.first.description.name == exercises[i].name) {
                thisExerciseList.add(sets.first);
                sets.removeAt(0);
              }

              return ListTile(
                horizontalTitleGap: 0,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ExerciseDescriptionScreen(
                        thisExercise: exercises[i],
                      );
                    },
                  ));
                },
                title: Text(exercises[i].name),
                subtitle: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: thisExerciseList.length,
                  itemBuilder: (context, j) {
                    return thisExerciseList[j].description.exerciseType ==
                            DetailType.strength
                        ? StrengthDescriptionHistory(
                            details:
                                thisExerciseList[j].details as StrengthDetails)
                        : CardioDescriptionHistory(
                            details:
                                thisExerciseList[j].details as CardioDetails);
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
