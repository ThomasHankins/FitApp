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

  List<bool> selectedExercises = [];
  List<Exercise> exercisesToAdd = [];
  @override
  void initState() {
    super.initState();
    if (exerciseList.isEmpty) {
      loadExerciseDescription();
    }
    selectedExercises = List.generate(exerciseList.length, (i) => false);
    exercisesToAdd = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
                "Choose Exercises to Add"), //TODO: will replace with search later
            //TODO: finish customizing app bar
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text("Add"),
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                widget.currentExercises.addAll(exercisesToAdd);
                widget.notifyParent();
                Navigator.pop(context);
              });
            },
          ),
          body: Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: exerciseList.length,
                itemExtent: 50,
                itemBuilder: (context, i) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: .2),
                    child: ListTile(
                      textColor: Colors.white,
                      title: Text(exerciseList[i].name),
                      selected: selectedExercises[i],
                      onTap: () {
                        setState(() {
                          selectedExercises[i] = !selectedExercises[i];
                        });
                        if (selectedExercises[i]) {
                          exercisesToAdd.add(
                            Exercise(
                              exerciseList[i].name,
                              [],
                            ),
                          );
                        } else {
                          exercisesToAdd.removeWhere((exercise) =>
                              exercise.name == exerciseList[i].name);
                        }
                      },
                      onLongPress: () {
                        //TODO Open Description Page
                      },
                    ),
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
