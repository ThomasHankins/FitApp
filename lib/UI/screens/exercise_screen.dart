import 'package:fit_app/UI/components/dissmissible_widget.dart';
import 'package:flutter/material.dart';

import '../../workout-tracker/exercise.dart';
import '../components/set_widget.dart';

class ExerciseScreen extends StatefulWidget {
  final Exercise thisExercise;

  ExerciseScreen({required this.thisExercise});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
  }

  int currentSetIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueGrey[900],
          body: Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.thisExercise.sets.length,
                itemBuilder: (context, i) {
                  return DismissibleWidget(
                    item: widget.thisExercise.sets[i],
                    onDismissed: (DismissDirection) {
                      setState(() {
                        if(currentSetIndex > i){
                          currentSetIndex -= 1;
                          widget.thisExercise.sets.removeAt(i);
                        } else if (currentSetIndex == i){
                          if(currentSetIndex != widget.thisExercise.sets.length){
                            widget.thisExercise.sets.removeAt(i);
                          } else{
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          widget.thisExercise.sets.add(
                            ExerciseSet(10, 10, false, ""),
                          );
                        });
                      },
                      minWidth: 50.0,
                      child: Text(
                        "Add Set",
                      ),
                      height: 42.0,
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: (){
                        setState(() {
                          //mark "finished set"
                          if(widget.thisExercise.sets.isNotEmpty){
                            widget.thisExercise.sets[currentSetIndex].completeSet();
                            if(currentSetIndex < widget.thisExercise.sets.length -1){
                              currentSetIndex++;
                            }
                            else{
                              Navigator.pop(context);
                            }
                          }

                        });
                      },
                      minWidth: 50.0,
                      child: Text(
                        "Log Exercise",
                      ),
                      height: 42.0,
                    ),
                  ),
                ],
              ),
              Text("Current Index :" + currentSetIndex.toString())
            ],
          ),
        ),
      ),
    );
  }
}
