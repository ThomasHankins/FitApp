import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/UI/screens/exercise_description_screen/exercise_description_components/strength__description_history_widget.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

import 'cardio_description_history_widget.dart';

class DescriptionHistoryContainer extends StatelessWidget {
  final List<Map<DateTime, ExerciseSet>> history;
  const DescriptionHistoryContainer({
    required this.history,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DateTime> uniqueDates =
        history.fold(<DateTime>[], (List<DateTime> list, item) {
      if (list.contains(DateTime(
          item.keys.first.year, item.keys.first.month, item.keys.first.day))) {
        list.add(DateTime(
            item.keys.first.year, item.keys.first.month, item.keys.first.day));
      }
      return list;
    });
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: uniqueDates.length,
      itemBuilder: (context, i) {
        //list that contains all elements from that day
        List<ExerciseSet> todaySets =
            history.fold(<ExerciseSet>[], (List<ExerciseSet> sets, item) {
          if (item.keys.first.isSameDate(uniqueDates[i])) {
            sets.add(item.values.first);
          }
          return sets;
        });

        return ListTile(
          horizontalTitleGap: 0,
          title: Text(ClockConverter().iso8601ToFormatted(uniqueDates[i])),
          subtitle: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: todaySets.length,
            itemBuilder: (context, j) {
              ExerciseSet thisSet = todaySets[j];
              return thisSet.description.exerciseType == DetailType.strength
                  ? StrengthDescriptionHistory(
                      details: thisSet.details as StrengthDetails)
                  : CardioDescriptionHistory(
                      details: thisSet.details as CardioDetails);
            },
          ),
        );
      },
    );
  }
}
