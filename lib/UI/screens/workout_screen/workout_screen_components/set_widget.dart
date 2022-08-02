import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StrengthSetWidget extends StatefulWidget {
  const StrengthSetWidget({
    Key? key,
    required ExerciseSet inheritSet,
    required Function() notifyParent,
  })  : _thisSet = inheritSet,
        _notifyParent = notifyParent,
        super(key: key);
  final ExerciseSet _thisSet;
  final Function() _notifyParent;

  @override
  _StrengthSetWidgetState createState() => _StrengthSetWidgetState();
}

//TODO completely overhaul
class _StrengthSetWidgetState extends State<StrengthSetWidget> {
  late ExerciseSet _thisSet;
  late StrengthDetails _details;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  String _thisWeightToString() {
    //TODO bring this into the set as a getter
    return _details.weight.toStringAsFixed(
        _details.weight.truncateToDouble() == _details.weight ? 0 : 1);
  }

  TextSelection _endOfSelection(TextEditingController controller) {
    return TextSelection(
      baseOffset: controller.text.length,
      extentOffset: controller.text.length,
    );
  }

  @override
  void initState() {
    _thisSet = widget._thisSet;
    _details = _thisSet.details as StrengthDetails;
    _weightController.text = _thisWeightToString();
    _repsController.text = _details.reps.toString();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    _weightController.text = _thisWeightToString();
    _repsController.text = _details.reps.toString();
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    //
    return ListTile(
      selected: _thisSet.isComplete,
      style: Theme.of(context).listTileTheme.style,
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
              controller: _weightController,
              enableInteractiveSelection: false,
              enabled: !_thisSet.isComplete,
              maxLength: 4,
              decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: _thisWeightToString()),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/./-]')),
              ],
              keyboardType: TextInputType.number,
              onTap: () => _weightController.text = "",
              onFieldSubmitted: (changes) {
                _weightController.text = _thisWeightToString();
                _weightController.selection =
                    _endOfSelection(_weightController);
                widget._notifyParent;
                setState(() {});
              },
              onChanged: (changes) {
                if (changes[0] == "0") {
                  if (changes.length > 1) {
                    _weightController.text = changes.substring(1);
                  } else {
                    _weightController.text = "0";
                  }
                  _weightController.selection =
                      _endOfSelection(_weightController);
                }
                try {
                  _details.weight = double.parse(changes);
                } catch (e) {
                  if (changes != "-" && changes != ".") {
                    _weightController.text = _thisWeightToString();
                    _weightController.selection =
                        _endOfSelection(_weightController);
                  }
                }
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
              controller: _repsController,
              enableInteractiveSelection: false,
              enabled: !_thisSet.isComplete,
              maxLength: 3,
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                hintText: _details.reps.toString(),
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              keyboardType: TextInputType.number,
              onTap: () => _repsController.text = "",
              onFieldSubmitted: (changes) {
                _repsController.text = _details.reps.toString();
                _repsController.selection = _endOfSelection(_repsController);
                widget._notifyParent;
              },
              onChanged: (changes) {
                if (changes[0] == "0") {
                  if (changes.length > 1) {
                    _repsController.text = changes.substring(1);
                  } else {
                    _repsController.text = "0";
                  }
                  _repsController.selection = _endOfSelection(_repsController);
                }
                try {
                  _details.reps = int.parse(changes);
                } catch (e) {
                  if (changes != "-" && changes != ".") {
                    _repsController.text = _details.reps.toString();
                    _repsController.selection =
                        _endOfSelection(_repsController);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }
}