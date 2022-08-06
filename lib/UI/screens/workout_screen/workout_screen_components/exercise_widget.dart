import 'package:fit_app/UI/components/tuples.dart';
import 'package:fit_app/UI/screens/workout_screen/workout_screen_components/set_widget.dart';
import 'package:fit_app/UI/screens/workout_screen/workout_screen_components/strength_tile_expanded.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

import 'dismissible_widget.dart';

class ExerciseWidget extends StatefulWidget {
  final Tuple<int, int> _setsRange;
  final ExerciseDescription _exerciseDescription;
  final LiveWorkout _thisWorkout;
  const ExerciseWidget(
      {Key? key,
      required LiveWorkout thisWorkout,
      required Tuple<int, int> exerciseSets,
      required ExerciseDescription ed})
      : _thisWorkout = thisWorkout,
        _exerciseDescription = ed,
        _setsRange = exerciseSets,
        super(key: key);

  @override
  _ExerciseWidgetState createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {
  late LiveWorkout _thisWorkout;
  late ExerciseDescription _exerciseDescription;
  late Tuple<int, int> _setsRange;
  @override
  void initState() {
    _thisWorkout = widget._thisWorkout;
    _exerciseDescription = widget._exerciseDescription;
    _setsRange = widget._setsRange;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //will become expandable widget
      SizedBox(child: Text(_exerciseDescription.name), height: 30),
      ReorderableListView.builder(
        shrinkWrap: true,
        itemCount: _setsRange.b - _setsRange.a + 1,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            _thisWorkout.reorderSet(
                _setsRange.a + oldIndex, _setsRange.a + newIndex);
            setState(() {});
          });
        },
        itemBuilder: (context, i) {
          return DismissibleWidget(
            onDismissed: (dismissDirection) {
              _thisWorkout.deleteSet(_setsRange.a + i);
            },
            key: Key('$i'),
            item: _thisWorkout.sets[_setsRange.a + i],
            child: Container(
                height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: .2),
                child: _thisWorkout.currentSetIndex != i
                    ? StrengthSetWidget(
                        inheritSet: _thisWorkout.sets[i],
                        notifyParent: () {
                          setState(() {});
                        },
                      )
                    : StrengthSetExpandedWidget(
                        inheritSet: _thisWorkout.sets[i],
                        notifyParent: () {
                          setState(() {});
                        },
                      )),
          );
        },
      ),
    ]);
  }
}
