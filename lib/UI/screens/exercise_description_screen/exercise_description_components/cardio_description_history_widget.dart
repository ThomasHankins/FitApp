import 'package:fit_app/UI/components/clock_converter.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

class CardioDescriptionHistory extends StatelessWidget {
  final CardioDetails details;
  const CardioDescriptionHistory({
    required this.details,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(details.distance.toString() +
        ' in ' +
        ClockConverter().secondsToFormatted(details.duration).toString());
  }
}
