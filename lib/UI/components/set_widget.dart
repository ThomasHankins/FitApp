import 'package:fit_app/workout-tracker/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetWidget extends StatelessWidget {
  SetWidget({required this.thisSet});
  final ExerciseSet thisSet;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text("Weight "),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 50,
              minWidth: 50,
            ),
            child: TextFormField(
              enabled: !thisSet.isComplete(),
              maxLength: 4,
              initialValue: thisSet.getWeight().toString(),
              decoration:
                  InputDecoration(counterText: "", border: InputBorder.none),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              keyboardType: TextInputType.number,
              onChanged: (changes) {
                thisSet.exerciseSetWeight(int.parse(changes));
              },
            ),
          ),
          Text("Reps "),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 50,
              minWidth: 50,
            ),
            child: TextFormField(
              enabled: !thisSet.isComplete(),
              maxLength: 4,
              initialValue: thisSet.getReps().toString(),
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.allow(RegExp('.')),
              ],
              keyboardType: TextInputType.number,
              onChanged: (changes) {
                thisSet.exerciseSetReps(int.parse(changes));
              },
            ),
          ),
          Text("Is Done "),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 50,
              minWidth: 50,
            ),
            child: Text(thisSet.isComplete().toString())
          ),
        ],
      ),
    );
  }
}
