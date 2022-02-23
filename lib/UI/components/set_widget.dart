import 'package:fit_app/workout-tracker/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetWidget extends StatelessWidget {
  const SetWidget({Key? key, required this.thisSet}) : super(key: key);
  final ExerciseSet thisSet;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: thisSet.isComplete,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Weight "),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 50,
              minWidth: 50,
            ),
            child: TextFormField(
              enabled: !thisSet.isComplete,
              maxLength: 4,
              initialValue: thisSet.weight.toString(),
              decoration: const InputDecoration(
                  counterText: "", border: InputBorder.none),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              keyboardType: TextInputType.number,
              onChanged: (changes) {
                thisSet.selectWeight = int.parse(changes);
              },
            ),
          ),
          const Text("Reps "),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 50,
              minWidth: 50,
            ),
            child: TextFormField(
              enabled: !thisSet.isComplete,
              maxLength: 4,
              initialValue: thisSet.reps.toString(),
              decoration: const InputDecoration(
                counterText: "",
                border: InputBorder.none,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.allow(RegExp('.')),
              ],
              keyboardType: TextInputType.number,
              onChanged: (changes) {
                thisSet.selectReps = int.parse(changes);
              },
            ),
          ),
        ],
      ),
    );
  }
}
