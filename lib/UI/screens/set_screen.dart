import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/data_structures/structures.dart';
import '../components/set_widget.dart';

class SetScreen extends StatefulWidget {
  final LiveWorkout thisWorkout;
  final int index;

  const SetScreen({Key? key, required this.thisWorkout, required this.index})
      : super(key: key);

  @override
  _SetScreenState createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  late final LiveExercise thisExercise;
  @override
  void initState() {
    thisExercise = widget.thisWorkout.exercises[widget.index];
    super.initState();
  }

  int currentSetIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Text(thisExercise.description.name),
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
              itemCount: thisExercise.sets.length,
              itemBuilder: (context, i) {
                return DismissibleWidget(
                  item: thisExercise.sets[i],
                  key: Key('$i'),
                  onDismissed: (dismissDirection) {
                    setState(() {
                      if (currentSetIndex > i) {
                        currentSetIndex -= 1;
                        thisExercise.deleteSet(i);
                      } else if (currentSetIndex == i) {
                        if (currentSetIndex != thisExercise.sets.length) {
                          thisExercise.deleteSet(i);
                        } else {
                          currentSetIndex -= 1;
                          thisExercise.deleteSet(i);
                          Navigator.pop(context);
                        }
                      } else {
                        thisExercise.deleteSet(i);
                      }
                    });
                  },
                  child: SetWidget(inheritSet: thisExercise.sets[i]),
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
                        thisExercise.addSet();
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
              if (thisExercise.sets.isNotEmpty) {
                thisExercise.sets[currentSetIndex].complete(
                    currentSetIndex, widget.index, widget.thisWorkout.id);
                if (currentSetIndex < thisExercise.sets.length - 1) {
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
