import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetWidget extends StatelessWidget {
  const SetWidget({Key? key, required LiveAction inheritSet})
      : thisSet = inheritSet as LiveSet,
        super(key: key);
  final LiveSet thisSet;

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
                thisSet.weight = double.parse(changes);
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
                thisSet.reps = int.parse(changes);
              },
            ),
          ),
        ],
      ),
    );
  }
}
