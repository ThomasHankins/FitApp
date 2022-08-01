import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

class StrengthDescriptionHistory extends StatelessWidget {
  final StrengthDetails details;
  const StrengthDescriptionHistory({
    required this.details,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(details.reps.toString() +
        ' x ' +
        details.weight.toStringAsFixed(
            details.weight.truncateToDouble() == details.weight ? 0 : 1) +
        'lbs');
  }
}
