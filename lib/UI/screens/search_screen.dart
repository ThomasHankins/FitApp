import 'dart:convert' show json;

import 'package:fit_app/workout-tracker/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseSearch extends StatefulWidget {
  final List<Exercise> currentExercises;
  final Function() notifyParent;

  ExerciseSearch({required this.currentExercises, required this.notifyParent});

  @override
  _ExerciseSearchState createState() => _ExerciseSearchState();
}

class _ExerciseSearchState extends State<ExerciseSearch> {
  static final List<ExerciseDescription> exerciseList = [];
  void loadExerciseDescription() async {
    var jsonText = await rootBundle.loadString("data/exercises.json");
    setState(() {
      List<dynamic> jsonData = json.decode(jsonText);
      for (Map<String, dynamic> jsonExercise in jsonData) {
        exerciseList.add(
          ExerciseDescription(
            jsonExercise["name"].toString(),
            jsonExercise["description"].toString(),
          ),
        );
      }
      ;
    });
  }

  @override
  void initState() {
    //should have debugging on call so we know if file got opened
    super.initState();
    if (exerciseList.isEmpty) {
      loadExerciseDescription();
    }
  }

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
                itemCount: exerciseList.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(exerciseList[i].name),
                    onTap:
                        null, //in the future I would like this to open up a description page
                    onLongPress: () {
                      setState(() {
                        widget.currentExercises.add(
                          Exercise(
                            exerciseList[i].name,
                            [],
                          ),
                        );
                        widget.notifyParent();
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
