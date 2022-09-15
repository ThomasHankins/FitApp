import 'package:fit_app/UI/screens/workout_screen/workout_screen_components/set_widget.dart';
import 'package:fit_app/UI/screens/workout_screen/workout_screen_components/strength_tile_expanded.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:fit_app/workout-tracker/data_structures/tuples.dart';
import 'package:flutter/material.dart';

import 'dismissible_widget.dart';

class ExerciseWidget extends StatefulWidget {
  final Tuple<int, int> _setsRange;
  final ExerciseDescription _exerciseDescription;
  final LiveWorkout _thisWorkout;
  final Function() _notifyParent;
  const ExerciseWidget(
      {Key? key,
      required Function() notifyParent,
      required LiveWorkout thisWorkout,
      required Tuple<int, int> exerciseSets,
      required ExerciseDescription ed})
      : _notifyParent = notifyParent,
        _thisWorkout = thisWorkout,
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

  void refreshExercises() {
    setState(() {});
    widget._notifyParent();

  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //will become expandable widget
      SizedBox(child: Text(_exerciseDescription.name), height: 30),
      ListView.builder(
        shrinkWrap: true,
        itemCount: _setsRange.b - _setsRange.a + 1,
        itemBuilder: (context, i) {
          return DismissibleWidget(
            onDismissed: (dismissDirection) {
              _thisWorkout.deleteSet(_setsRange.a + i);
              refreshExercises();
            },
            key: Key('$i'),
            item: _thisWorkout.sets[_setsRange.a + i],
            child: Container(
                height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: .2),
                child: _thisWorkout.currentSetIndex != i
                    ? StrengthSetExpandedWidget(
                  inheritSet: _thisWorkout.sets[_setsRange.a + i],
                  notifyParent: refreshExercises,
                  logSet: (){_thisWorkout.sets[_setsRange.a + i].complete(_thisWorkout.id, _thisWorkout.workoutTimer.elapsed.inSeconds, _setsRange.a + i);},
                )
                    : StrengthSetExpandedWidget(
                        inheritSet: _thisWorkout.sets[_setsRange.a + i],
                        notifyParent: refreshExercises,
                        logSet: (){
                          _thisWorkout.sets[_setsRange.a + i].complete(_thisWorkout.id, _thisWorkout.workoutTimer.elapsed.inSeconds, _setsRange.a + i);
                          widget._notifyParent;
                          },
                      )),
          );
        },
      ),
    ]);
  }
}
