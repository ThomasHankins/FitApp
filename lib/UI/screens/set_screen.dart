import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/data_structures/exercise.dart';
import '../components/set_widget.dart';

class SetScreen extends StatefulWidget {
  final Exercise thisExercise;

  const SetScreen({Key? key, required this.thisExercise}) : super(key: key);

  @override
  _SetScreenState createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  @override
  void initState() {
    super.initState();
  }

  int currentSetIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Text(widget.thisExercise.description.name),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.info,
              ),
              onPressed: () async {
                setState(() {
//TODO go to exercise description screen
                });
              },
            ),
          ]),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.thisExercise.sets.length,
              itemBuilder: (context, i) {
                return DismissibleWidget(
                  item: widget.thisExercise.sets[i],
                  key: Key('$i'),
                  onDismissed: (dismissDirection) {
                    setState(() {
                      if (currentSetIndex > i) {
                        currentSetIndex -= 1;
                        widget.thisExercise.sets.removeAt(i);
                      } else if (currentSetIndex == i) {
                        if (currentSetIndex !=
                            widget.thisExercise.sets.length) {
                          widget.thisExercise.sets.removeAt(i);
                        } else {
                          currentSetIndex -= 1;
                          widget.thisExercise.sets.removeAt(i);
                          Navigator.pop(context);
                        }
                      } else {
                        widget.thisExercise.sets.removeAt(i);
                      }
                    });
                  },
                  child: SetWidget(thisSet: widget.thisExercise.sets[i]),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.grey[850],
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        widget.thisExercise.sets.add(
                          ExerciseSet.fromBlank(widget.thisExercise.id,
                              widget.thisExercise.sets.length),
                        );
                      });
                    },
                    minWidth: 50.0,
                    child: const Text(
                      "Add Set",
                    ),
                    height: 42.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Log Set"),
          icon: const Icon(Icons.check),
          onPressed: () {
            setState(() {
              //mark "finished set"
              if (widget.thisExercise.sets.isNotEmpty) {
                widget.thisExercise.sets[currentSetIndex].completeSet();
                if (currentSetIndex < widget.thisExercise.sets.length - 1) {
                  currentSetIndex++;
                } else {
                  Navigator.pop(context);
                }
              }
            });
          },
        ),
      ),
    );
  }
}
