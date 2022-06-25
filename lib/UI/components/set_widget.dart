import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetWidget extends StatelessWidget with ChangeNotifier {
  SetWidget({Key? key, required LiveAction inheritSet})
      : _thisSet = inheritSet as LiveSet,
        super(key: key);
  final LiveSet _thisSet;

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String _thisWeightToString() {
      //TODO bring this into the set as a getter
      return _thisSet.weight.toStringAsFixed(
          _thisSet.weight.truncateToDouble() == _thisSet.weight ? 0 : 1);
    }

    _weightController.text = _thisWeightToString();
    _repsController.text = _thisSet.reps.toString();
    TextSelection _endOfSelection(TextEditingController controller) {
      return TextSelection(
        baseOffset: controller.text.length,
        extentOffset: controller.text.length,
      );
    }

    //
    return ListTile(
      selected: _thisSet.isComplete,
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
                  _thisSet.weight = double.parse(changes);
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
                hintText: _thisSet.reps.toString(),
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              keyboardType: TextInputType.number,
              onTap: () => _repsController.text = "",
              onFieldSubmitted: (changes) {
                _repsController.text = _thisSet.reps.toString();
                _repsController.selection = _endOfSelection(_repsController);
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
                  _thisSet.reps = int.parse(changes);
                } catch (e) {
                  if (changes != "-" && changes != ".") {
                    _repsController.text = _thisSet.reps.toString();
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
