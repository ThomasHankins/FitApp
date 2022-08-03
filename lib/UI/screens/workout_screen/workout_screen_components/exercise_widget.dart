import 'package:fit_app/UI/components/tuples.dart';
import 'package:fit_app/UI/screens/workout_screen/workout_screen_components/set_widget.dart';
import 'package:fit_app/UI/screens/workout_screen/workout_screen_components/strength_tile_expanded.dart';
import 'package:fit_app/workout-tracker/data_structures/structures.dart';
import 'package:flutter/material.dart';

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

//TODO completely overhaul
class _ExerciseWidgetState extends State<ExerciseWidget> {
  late LiveWorkout _thisWorkout;
  late ExerciseDescription _exerciseDescription;
  late Tuple<int, int> _setsRange;
  @override
  void initState() {
    super.initState();
    _thisWorkout = widget._thisWorkout;
    _exerciseDescription = widget._exerciseDescription;
    _setsRange = widget._setsRange;
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        //will become expandable widget
        SliverToBoxAdapter(
            child:
                SizedBox(child: Text(_exerciseDescription.name), height: 20)),
        SliverReorderableList(
          itemCount: _setsRange.b - _setsRange.a,
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
            return Container(
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
                        //TODO configure to allow additional option of "finished vs non-finished"
                        inheritSet: _thisWorkout.sets[i],
                        notifyParent: () {
                          setState(() {});
                        },
                      ));
          },
        ),
      ]),
    );
  }
}
